# OpenSecurityTraining2 Arch1001: Lab RTFM && WTFI!

## 1. Giới thiệu & Yêu cầu đề bài (Challenge Description)
Trong bài Lab **"RTFM && WTFI!" (Read The Fun Manual and Write The Fun Instructions!)** thuộc khóa học *OST2 Arch1001: x86-64 Assembly* của giảng viên **Xeno Kovah**, học viên được yêu cầu thực hiện thử thách sau:

* **Yêu cầu:** Không được viết code Assembly bằng các từ gợi nhớ (Mnemonics) dễ đọc cho con người như thông thường. Thay vào đó, hãy tự tra cứu tài liệu chính thức của Intel (**Intel® 64 and IA-32 Architectures Software Developer's Manual - SDM**) để tìm mã máy (Opcode) và sử dụng chỉ thị **`db` (Define Byte)** trong MASM nhằm phát sinh ra chuỗi byte thô tương ứng với đoạn code Assembly dưới đây:

```assembly
mov eax, 0xAABBCCDD
sahf ; What's that? IDK, RTFM!
jz mylabel
and eax, 0x31337
mylabel:
ret
```

* **Mục tiêu:** 
  1. Nắm vững cách đọc bảng *Instruction Set Reference* trong Intel SDM (Vol. 2A & Vol. 2B).
  2. Hiểu rõ cách CPU giải mã từng byte lệnh trên bộ nhớ theo kiến trúc **Little-Endian**.
  3. Tự tính toán được khoảng cách nhảy tương đối (`rel8` / `cb`) của lệnh nhảy có điều kiện `jz`.
  4. Kiểm chứng bằng trình Disassembler của Visual Studio xem các byte thô mình viết ra có được dịch ngược lại đúng thành đoạn code của đề bài hay không.

---

## 2. Cấu trúc Mã nguồn trong Project (`main.c` & `raw_bytecode.asm`)

Để thực thi và gỡ lỗi (debug) chuỗi byte thô trong Visual Studio, bài Lab sử dụng 2 file kết hợp với nhau:

### A. File bàn đạp [`main.c`](./main.c)
```c
extern void asm_scratchpad();

void main()
{
    asm_scratchpad();
}
```
* **Tại sao cần `main.c`?** Trình biên dịch của Visual Studio cần một điểm khởi đầu chuẩn trong ngôn ngữ C là hàm `main()`. File `main.c` đóng vai trò làm "bàn đạp" (wrapper) để gọi nhảy sang hàm Assembly.
* **Từ khóa `extern`:** Báo cho trình biên dịch C biết hàm `asm_scratchpad()` không nằm trong file `.c` này mà được định nghĩa ở một file bên ngoài (`raw_bytecode.asm`). Khi biên dịch, Linker sẽ tự động kết nối lời gọi hàm trong `main()` tới đúng địa chỉ của `asm_scratchpad` bên file Assembly.

### B. File chứa mã máy [`raw_bytecode.asm`](./raw_bytecode.asm)
* Khai báo chỉ thị `PUBLIC asm_scratchpad` để xuất (export) tên hàm ra ngoài cho file `main.c` nhìn thấy.
* Toàn bộ phần thân hàm bên trong cặp `asm_scratchpad PROC` ... `asm_scratchpad ENDP` chỉ sử dụng chỉ thị **`db`** để nhét trực tiếp các byte mã máy vào phân vùng `.code` trên RAM.

---

## 3. Quá trình Tra cứu Intel SDM & Giải mã từng lệnh (Walkthrough)

### Lệnh 1: `mov eax, 0xAABBCCDD`
* **Vị trí tra cứu:** *Intel SDM Vol. 2B — Mục `MOV—Move`*.
* **Khuôn mẫu khớp:** `MOV r32, imm32` (Nạp một hằng số tức thời 32-bit vào thanh ghi 32-bit).
* **Cột Opcode:** **`B8+ rd id`**
  * **`B8+ rd`:** Tra bảng *Table 3-1 (Register Codes)* ở trang `3-2` (Vol. 2A), thanh ghi 32-bit `EAX` có mã `Reg Field = 0`. Do đó byte Opcode đầu tiên là: `B8h + 0 = 0B8h`.
  * **`id` (4-byte immediate):** Giá trị `0xAABBCCDD` khi lưu xuống bộ nhớ x86-64 theo chuẩn **Little-Endian** (byte có trọng số thấp đứng ở địa chỉ thấp) phải được đảo ngược thứ tự từng byte thành: `0DDh, 0CCh, 0BBh, 0AAh`.
* **Cú pháp MASM:** Trong MASM, các số Hex bắt đầu bằng chữ cái (`A–F`) bắt buộc phải có số `0` đứng trước để không bị nhầm với tên định danh.
* **Kết quả:** `db 0B8h, 0DDh, 0CCh, 0BBh, 0AAh` *(Tổng cộng: 5 bytes)*

---

### Lệnh 2: `sahf` (; What's that? IDK, RTFM!)
* **Vị trí tra cứu:** *Intel SDM Vol. 1 (Mục 7.3.13.2) & Vol. 2B (Mục `SAHF—Store AH Into Flags`)*.
* **Chức năng:** Lệnh `SAHF` lấy trực tiếp các bit `7, 6, 4, 2, 0` từ thanh ghi 1-byte **`AH`** và ghi đè lần lượt vào các cờ trạng thái **`SF, ZF, AF, PF, CF`** trong thanh ghi `EFLAGS`.
* **Cột Opcode:** **`9E`**
* **Kết quả:** `db 9Eh` *(Tổng cộng: 1 byte)*

---

### Lệnh 3 & 4: `jz mylabel` và `and eax, 0x31337`
* **Vị trí tra cứu `jz`:** *Intel SDM Vol. 2A (Trang `3-499`) — Mục `Jcc—Jump if Condition Is Met`*.
  * Lệnh nhảy ngắn `JZ rel8` (nhảy nếu cờ `ZF = 1`) có Opcode là **`74 cb`**.
  * Trong đó, `cb` là số byte độ dời tương đối (1-byte relative offset) tính từ **ngay sau lệnh `jz`** cho đến nhãn đích `mylabel:`.
* **Tính toán độ dài lệnh `and eax, 0x31337` để tìm `cb`:**
  * Để nhảy từ sau lệnh `jz` vượt qua lệnh `and eax, 0x31337` và đáp trúng nhãn `mylabel:` (nằm ngay đầu lệnh `ret`), ta phải tính xem lệnh `and eax, 0x31337` chiếm bao nhiêu byte.
  * Tra cứu *Intel SDM Vol. 2A (Trang `3-60`) — Mục `AND—Logical AND`*, ta thấy khuôn mẫu tối ưu dành riêng cho thanh ghi `EAX`: **`AND EAX, imm32`** có Opcode là **`25 id`**.
  * Byte Opcode đầu tiên là `25h`.
  * Phần `id` bắt buộc phải đủ **4 bytes (32-bit)**. Con số `0x31337` viết đầy đủ 4 bytes là `0x00031337`, khi xếp theo chuẩn Little-Endian sẽ thành: `37h, 13h, 03h, 00h`.
  * $\rightarrow$ Lệnh `and` hoàn chỉnh là `db 25h, 37h, 13h, 03h, 00h`, chiếm tổng cộng **5 bytes (`5h`)**.
* **Suy ra lệnh `jz`:** Cần nhảy tiến về phía trước **5 bytes** (`cb = 5h`).
* *(Lưu ý: Nhãn `mylabel:` chỉ là điểm đánh dấu vị trí nên không tốn byte mã máy nào).*
* **Kết quả lệnh `jz`:** `db 74h, 5h` *(2 bytes)*
* **Kết quả lệnh `and`:** `db 25h, 37h, 13h, 03h, 00h` *(5 bytes)*

---

### Lệnh 5: `ret`
* **Vị trí tra cứu:** *Intel SDM Vol. 2B — Mục `RET—Return From Procedure`*.
* **Cột Opcode (Near return):** **`C3`**
* **Kết quả:** `db 0C3h` *(Tổng cộng: 1 byte)*

---

## 4. Tổng hợp Code hoàn chỉnh & Phân tích Kết quả Debug

```assembly
PUBLIC asm_scratchpad

.code
asm_scratchpad PROC
    ;code goes here
    db 0B8h, 0DDh, 0CCh, 0BBh, 0AAh ; mov eax, 0AABBCCDDh (5 bytes)
    db 9Eh                          ; sahf                (1 byte)
    db 74h, 5h                      ; jz/je $+5           (2 bytes)
    db 25h, 37h, 13h, 03h, 00h      ; and eax, 31337h     (5 bytes)
    db 0C3h                         ; ret                 (1 byte)
asm_scratchpad ENDP
end
```

### Giải thích hiện tượng khi chạy trên Visual Studio Debugger:
1. **Tại sao Disassembler hiển thị `je` thay vì `jz`?**
   Trong kiến trúc x86-64, `JE` (*Jump if Equal*) và `JZ` (*Jump if Zero*) là 2 tên gọi (bí danh) của **cùng một Opcode `74h`** (cả hai đều kiểm tra điều kiện `ZF = 1`). Khi đọc byte `74h` từ bộ nhớ, trình dịch ngược của Visual Studio mặc định chọn in ra tên `je`.
2. **Lệnh `je` / `jz` có thực hiện bước nhảy không?**
   * Sau lệnh `mov eax, 0AABBCCDDh`, thanh ghi `EAX` chứa `0xAABBCCDD` $\rightarrow$ 16-bit thấp `AX` là `0xCCDD` $\rightarrow$ thanh ghi 8-bit cao **`AH` = `0xCC`**.
   * Biểu diễn nhị phân của `AH = 0xCC` (đánh số bit từ phải qua trái, bắt đầu từ bit `0` đến bit `7`):
     ```text
     AH = 0xCC:    1     1     0     0       1     1     0     0
     Vị trí Bit:  [7]   [6]   [5]   [4]     [3]   [2]   [1]   [0]
                  SF    ZF                  AF    PF          CF
     ```
   * Khi chạy lệnh `sahf`, **Bit số 6** của `AH` (đang bằng **`1`**) được nạp vào cờ **Zero Flag (`ZF`)**, khiến **`ZF = 1`**.
   * Do `ZF = 1`, lệnh `je` thỏa mãn điều kiện và **nhảy cóc 5 bytes** qua khỏi lệnh `and eax, 31337h`, đáp thẳng xuống lệnh `ret`. Kết thúc hàm, thanh ghi `EAX` bảo toàn nguyên vẹn giá trị `0xAABBCCDD`.
