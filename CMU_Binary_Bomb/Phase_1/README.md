# Phase 1: String Comparison

## 1. Nhận diện mục tiêu và dọn dẹp Boilerplate Code
Trong tất cả các phase, đoạn lệnh khởi đầu luôn là các thủ tục dọn dẹp và thiết lập Stack. Chúng ta chủ động bỏ qua các lệnh `push rbp`, `push rdi` (Calling Conventions để bảo toàn thanh ghi - Callee-save) cũng như các hàm setup của hệ thống như `__CheckForDebuggerJustMyCode`.

Trọng tâm bắt đầu ngay bên dưới đoạn check debugger, nơi xuất hiện lệnh tải địa chỉ:

```assembly
lea rdx, [bomb!'string' (address)]
```

![Phase 1 Disassembly](./images/phase1_asm.jfif)

Từ khóa `string` chỉ điểm rất rõ ràng rằng địa chỉ này đang chứa một chuỗi văn bản. Dùng lệnh `da <address>` (Dump ASCII) trong WinDbg để soi bộ nhớ, ta thu được chuỗi mục tiêu: `"I am just a renegade hockey mom."`.

## 2. Phân tích đối số và Hàm kiểm tra
Ngay dưới lệnh `lea rdx`, chương trình nạp dữ liệu vào thanh ghi thứ hai:

```assembly
mov rcx, [rbp + ...h]
```

Kiểm tra thanh ghi `rcx`, ta phát hiện đây chính là địa chỉ trỏ tới chuỗi INPUT mà chúng ta vừa nhập. Kế tiếp, chương trình thực thi `call strings_not_equal`. Theo chuẩn Microsoft x64 Calling Convention, `rcx` và `rdx` chính là hai tham số đầu vào (chuỗi INPUT và chuỗi đáp án) của hàm so sánh này.

## 3. Vượt qua cửa ải Logic
Sau khi hàm so sánh chạy xong, kết quả được lưu trong thanh ghi `EAX`. Đoạn code quyết định sinh tử:

```assembly
test eax, eax
je <address_thoát_bom>
call explode_bomb
```

Hàm `strings_not_equal` trả về `0` nếu hai chuỗi giống hệt nhau. Khi đó, lệnh `test eax, eax` (`0 AND 0`) cho kết quả `0`, kích hoạt cờ Zero Flag (`ZF = 1`). Lệnh `je` (Jump if Equal) thấy `ZF` bật sáng sẽ lập tức nhảy vọt qua lệnh `explode_bomb`. 

👉 **Answer (Phase 1):** `I am just a renegade hockey mom.`
