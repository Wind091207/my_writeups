# Phase 2: Loops and Arrays

## 1. Khám phá hàm đọc dữ liệu đầu vào
Sau khi vượt qua các lệnh dọn dẹp Stack ban đầu, luồng thực thi của chương trình dẫn thẳng đến một cụm lệnh chuẩn bị tham số và gọi hàm `read_six_numbers` thông qua lệnh `call bomb!ILT+205(read_six_numbers)`.

![Call read_six_numbers](./pic1.jfif)

Tiến sâu vào bên trong cơ chế đọc chuỗi, chúng ta thấy chương trình sử dụng hàm `sscanf` (`call bomb!ILT+705(sscanf)`) để phân tích dữ liệu nhập vào. Ngay sau đó, nó lưu kết quả trả về của `sscanf` (số lượng số nguyên đã đọc thành công) và kiểm tra bằng lệnh `cmp dword ptr [rbp+4], 6`. Lệnh `jge` (Jump if Greater or Equal) yêu cầu kết quả phải lớn hơn hoặc bằng 6.

![sscanf check](./pic2.jfif)

Nếu số lượng số đọc được không thỏa mãn điều kiện (nhỏ hơn 6), chương trình sẽ bỏ qua lệnh nhảy và rơi thẳng xuống bẫy `call bomb!ILT+945(explode_bomb)`. 

![explode bomb](./pic3.jfif)

Từ tổ hợp lệnh này, ta chốt được quy tắc đầu tiên: **Phase 2 bắt buộc người dùng phải nhập vào đúng 6 số nguyên.**

## 2. Điều kiện khởi đầu
Dựa vào bản dịch mã giả (pseudocode) xuất sắc ở bước phân tích logic tĩnh, chúng ta thấy 6 con số này được lưu trữ trong một mảng bắt đầu từ địa chỉ `[rbp + 28h]`. 

Chương trình khởi tạo `rax *= 0` và thực hiện bài test sinh tử đầu tiên:
```c
if([rbp + rax + 28h] == 1) { jump 00007ff7`675d20fc: ... }
else BOMB
```
Đoạn mã này trỏ thẳng vào phần tử đầu tiên của mảng (`index 0`) và ép buộc giá trị của nó phải bằng `1`, nếu sai lệch bom sẽ nổ ngay lập tức. 

👉 **Số thứ 1:** `1`

## 3. Dịch ngược Vòng lặp (The Loop)
Sau khi qua ải đầu tiên, chương trình thiết lập biến đếm `[rbp + 4] = 1` và tiến vào một vòng lặp phức tạp để kiểm tra 5 con số còn lại. 

![Loop Logic Analysis](./pic4.jfif)

Phân tích từng khối mã giả, ta bóc tách được quy luật của mảng:
*   **Điều kiện thoát:** Vòng lặp sẽ kết thúc và đi đến nhánh an toàn (PASSSSS) nếu biến đếm đạt điều kiện `if([rbp + 4] >= 6)`.
*   **Truy xuất phần tử trước đó:** Chương trình gán `ecx = [rbp + 4]` sau đó lùi lại một index (`ecx--`), dùng index lùi này để lấy giá trị phần tử đứng ngay trước nó thông qua `ecx = [rbp + rcx*4 + 28h]`.
*   **Phép toán cốt lõi:** Lấy giá trị của phần tử liền trước vừa trích xuất được và nhân lên 2 lần bằng lệnh `ecx *= 2;`.
*   **Kiểm tra tính hợp lệ:** Nó tiếp tục lấy giá trị phần tử tại index hiện tại `[rbp + rax*4 + 28h]` và so sánh trực tiếp với kết quả `ecx` (đã nhân 2) ở trên thông qua lệnh `if([rbp + rax*4 + 28h] == ecx)`. Nếu khớp, biến đếm tăng lên (`eax++`) để lặp tiếp, nếu không khớp sẽ rẽ nhánh `else BOMB`.

**Kết luận:**
Logic vòng lặp cực kỳ rõ ràng: **Số đứng sau bắt buộc phải bằng số đứng liền trước nó nhân cho 2**. 
Kết hợp với dữ kiện số đầu tiên là `1`, chúng ta có một cấp số nhân:
- Số thứ 1: `1`
- Số thứ 2: $1 \times 2 = 2$
- Số thứ 3: $2 \times 2 = 4$
- Số thứ 4: $4 \times 2 = 8$
- Số thứ 5: $8 \times 2 = 16$
- Số thứ 6: $16 \times 2 = 32$

👉 **Answer (Phase 2):** `1 2 4 8 16 32`
