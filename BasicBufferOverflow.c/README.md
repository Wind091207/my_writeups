# Challenge Description

![Picture 1](./images/BBO_pic1.jfif)

![Picture 2](./images/BBO_pic2.jfif)

**Objective:** Exploit a buffer overflow vulnerability to execute `AwesomeSauce()`.

Under normal execution, `AwesomeSauce()` is called only when `lame()` or `lame2()` returns `0`. Our goal is to bypass this restriction.

## A. Input Analysis

<p align="center">
  <img src="./images/BBO_pic3.jfif" width="48%" />
  <img src="./images/BBO_pic4.jfif" width="48%" />
</p>

The program accepts two command-line arguments: `argv[1]` and `argv[2]`. Meanwhile, `argv[0]` contains the executable's name or path.

Both inputs are initially strings and are converted into 64-bit integers using `_strtoi64`:

`size = _strtoi64(argv[1], "", 10);`

`value = _strtoi64(argv[2], "", 16);`

- `argv[1]`: Interpreted in base 10 and stored in `size`.
- `argv[2]`: Interpreted in base 16 and stored in `value`.

**Example:** Input `2 10` → `size = 2`, `value = 16 (0x10)`.

## B. Analyzing lame() and lame2()

We will analyze the Assembly instructions and reconstruct the stack layout using Visual Studio Debugger.

### B.1. lame()

#### 1. Stack initialization

![Picture 5](./images/BBO_pic5.jfif)

At the beginning of `main()`:

- `RCX` stores `argc` (argument count).
- `RDX` stores `argv` (pointer to the argument array).

Their values are saved at `[15FE40]` and `[15FE48]`, respectively.

The instruction `sub rsp, 38h` allocates stack space:

![Picture 6](./images/BBO_pic6.jfif)

#### 2. Input storage

<p align="center">
  <img src="./images/BBO_pic7.jfif" width="48%" />
  <img src="./images/BBO_pic8.jfif" width="48%" />
</p>

After `_strtoi64` processes both inputs:

- `size` → `[rsp + 28h]`
- `value` → `[rsp + 20h]`

Updated stack layout:

![Picture 8a](./images/BBO_pic8a.jfif)

#### 3. Entering lame()

![Picture 9](./images/BBO_pic9.png)

The highlighted instructions correspond to:

- `call lame()`
- `call lame2()`
- The instruction that calls `AwesomeSauce()`

Stepping into `lame()`, the `call` instruction pushes the return address onto the stack at `[15FDF8]`.

![Picture 10](./images/BBO_pic10.jfif)

Inside `lame()`:

- `RCX` contains `value` and is saved at `[15FE00]`.
- `sub rsp, 0A8h` → `RSP = 15FD50`.

The program initializes `array2[0]` through `array2[3]` with `value`.

| Element | Stack address |
|---|---|
| `array2[0]` | `15FD70` |
| `array2[1]` | `15FD78` |
| `array2[2]` | `15FD80` |
| `array2[3]` | `15FD88` |

#### 4. Analyzing memcpy()

![Picture 11](./images/BBO_pic11.jfif)

According to the Windows x64 calling convention, the first three arguments of `memcpy` are passed through:

- `RCX`: Destination (`array1`)
- `RDX`: Source (`array2`)
- `R8`: Number of bytes to copy (`40h` = 64 bytes)

The destination begins at:

`array1[0] = [rsp + 60h] = [15FDB0]`

Therefore, the destination range is:

- **Start:** `15FDB0`
- **End (exclusive):** `15FDB0 + 40h = 15FDF0`
- **Last byte:** `15FDEF`

The saved return address is located at `[15FDF8]`, outside the copied range.

**Conclusion:** `lame()` copies exactly 64 bytes into a 64-byte destination buffer. Therefore, this `memcpy` operation does not overflow `array1`, regardless of the supplied input values.

### B.2. lame2()

![Picture 12](./images/BBO_pic12.jfif)

Back in `main()`:

- `RSP = 15FE00`
- `RCX = [rsp + 28h]` → `size`
- `RDX = [rsp + 20h]` → `value`

Stepping into `lame2()`, the `call` instruction pushes the return address onto the stack:

`15FE00 - 8 = 15FDF8` and `15FDF8 = RET`

![Picture 13](./images/BBO_pic13.jfif)

Đầu hàm lame2() rcx và rdx lần lượt được lưu vào `15FDF8 + 8` và `15FDF8 + 10` tương đương input1 và input2.
`rsp = [15FDF8 - 88h] = 15FD70`

![Picture 14](./images/BBO_pic14.jfif)

Dựa vào ảnh ta có thể thấy được array2[5] = [15FD70 + 28h + 20h] = [15FDB8‬] = INPUT2 
Như vậy, ta suy ra được:
- `[15FDB0] = INPUT2`
- `[15FDA8] = INPUT2`
- `[15FDA0] = INPUT2`
- `[15FD98] = INPUT2`
- `[15FD90] = INPUT2`
=> Địa chỉ bắt đầu mảng array2 = [15FD90].

![Picture 15](./images/BBO_pic15.jfif)

Tới đây ta có thể được rax được lưu = INPUT1 và shl rax, 3.
Test INPUT1 = 3 => rax = 18h = 24 byte
Địa chỉ khởi đầu của 2 mảng array1 và array2 lần lượt được lưu vào `[15FD70 + 50h] = [15FDC0‬]` và `[15FD70 + 20h] = [15FD90]`

Tại đây bạn thấy rằng lệnh memcpy sẽ copy các phần tử của mảng array2 sang array1, lúc này bạn để ý địa chỉ chứa RET và địa chỉ khởi đầu của mảng 1 cách nhau khoảng  
