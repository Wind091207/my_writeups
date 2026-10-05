# Phase 3: Switch Statements (Jump Table)

## 1. Đọc dữ liệu đầu vào
Đầu tiên, ta bỏ qua các lệnh khởi tạo và tìm đến đoạn đọc dữ liệu. Bằng cách kiểm tra địa chỉ chuỗi (`00007ff7'675dc220`), ta thấy định dạng đầu vào là `"%d %d"`. 

Chương trình gọi hàm `sscanf` để đọc số. Sau đó, nó kiểm tra kết quả bằng lệnh `if([rbp + 64] >= 2)`. Nếu bạn nhập ít hơn 2 số, bom sẽ nổ. Vậy ta cần nhập chính xác **2 số nguyên**.

## 2. Kiểm tra số thứ nhất và Cấu trúc Switch-Case
Số đầu tiên bạn nhập được lưu ở `[rbp + 4]`. Chương trình xử lý con số này qua 2 chốt kiểm tra được lồng ghép với một cấu trúc nhảy gián tiếp (Jump Table):

*   **Bước 1 (Kiểm tra giới hạn của mảng):** Lệnh `if([rbp + 134] > 7)` nhìn thì giống kiểm tra lớn hơn 7, nhưng trong Assembly nó dùng lệnh so sánh không dấu (unsigned comparison). Nếu bạn nhập số âm (ví dụ -1), máy tính sẽ hiểu đó là 4.2 tỷ và nổ bom ngay lập tức. Lệnh này dùng để đảm bảo số nhập vào nằm trong khoảng từ 0 đến 7, giúp chương trình không bị lỗi khi truy cập mảng.
*   **Cấu trúc Switch-Case:** Ngay sau đó, đoạn code tính toán địa chỉ rồi gọi `jmp rax` chính là cấu trúc `switch-case` trong Assembly. Tùy vào giá trị của số thứ nhất (từ 0 đến 7), chương trình sẽ nhảy đến case tương ứng. Điểm đặc biệt là các case được viết liền nhau và không có lệnh `break` (hiệu ứng Fall-through). Ví dụ, nhập số 0, nó nhảy vào dòng `switch 0` và chạy tuột từ trên xuống dưới, thực hiện tất cả các phép tính.
*   **Bước 2 (Kiểm tra logic chính):** Nằm ở tít bên dưới, sau khi chạy xong hết các phép tính của switch-case, chương trình chốt lại bằng lệnh `if([rbp + 4] > 5)`. Điều này có nghĩa là nếu ở bước 1 bạn nhập số 6 hoặc 7, chương trình vẫn cho qua và chạy phép tính, nhưng đến đoạn cuối này bom mới nổ. 

=> **Kết luận:** Số thứ nhất bắt buộc phải nằm trong khoảng **[0, 5]**.

![Phase 3 Part 1](./phase3_pic2.jfif)
![Phase 3 Part 2](./phase3_pic3.jfif)

## 3. Tìm số thứ hai (Input 2)
Thay vì tự nhẩm các phép cộng trừ dài dòng, cách nhanh nhất là chạy Debug (Dynamic Analysis). 
Bạn đặt breakpoint ở ngay trước dòng kiểm tra cuối cùng `if([rbp + 44] == eax)`.

Ví dụ: Chọn số thứ nhất là `3`. Cho chương trình chạy qua đoạn switch-case, sau đó kiểm tra giá trị của `[rbp + 44]`. Lúc này nó sẽ bằng `0xffffff82` (hệ Hex).
Đổi `0xffffff82` ra số thập phân có dấu (dùng quy tắc bù 2), ta được `-126`.

Cuối cùng, chương trình lấy số thứ hai của mình (đang lưu ở `eax = [rbp + 24]`) ra so sánh xem có bằng `[rbp + 44]` không. Nếu bằng nhau, bạn sẽ qua màn.

👉 **Answer (Phase 3):** Có nhiều đáp án đúng tùy thuộc vào số thứ nhất (chọn từ 0 đến 5). Ví dụ:
* `1 -26`
* `3 -126`
