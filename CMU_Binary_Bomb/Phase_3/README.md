# Phase 3: Switch Statements (Jump Table)

## 1. Đọc dữ liệu đầu vào (Input Parsing)
Khởi đầu Phase 3, chúng ta bỏ qua các lệnh rác và tiến thẳng đến cụm nạp tham số. Bằng cách soi giá trị tại địa chỉ chuỗi (`00007ff7'675dc220`), ta nhận diện được Format String là `"%d %d"`. 

Chương trình gọi hàm `sscanf` thông qua lệnh `call bomb!ILT+705(sscanf)`. Ngay sau đó, kết quả trả về của hàm này được kiểm tra bằng điều kiện `if([rbp + 64] >= 2)`. 
Nếu số lượng biến đọc được nhỏ hơn 2, chương trình sẽ rẽ nhánh vào BOMB. Do đó, Phase này yêu cầu nhập chính xác **2 số nguyên**.

![Phase 3 Pseudocode](./phase3_pic1.jfif)

## 2. Kiểm duyệt số thứ nhất (First Input Validation)
Con số đầu tiên người dùng nhập vào được lưu tại `[rbp + 4]`. Tác giả đã giăng ra hai chốt chặn để giới hạn Input này:

*   **Chốt thứ nhất (So sánh không dấu với 7):** Ở đầu đoạn mã có lệnh `if([rbp + 134] > 7) { jump (BOMB) }`. Mặc dù thoạt nhìn có vẻ nó chỉ chặn các số lớn hơn 7, nhưng trong Assembly, lệnh kiểm tra này thường dùng `ja` (Jump if Above - so sánh không dấu). Nếu người dùng nhập số âm (ví dụ: `-1`), theo quy tắc bù 2 của máy tính, `-1` sẽ được hiểu là `0xFFFFFFFF` (khoảng 4.2 tỷ). Do 4.2 tỷ > 7, hệ thống lập tức đá văng số âm vào thẳng hàm nổ bom. Đây là kỹ thuật tối ưu hóa kinh điển của trình biên dịch: dùng một lệnh duy nhất để chặn cả bounds trên (số lớn) lẫn bounds dưới (số âm).
*   **Chốt thứ hai (So sánh có dấu với 5):** Nằm ở cuối mớ bòng bong code `if([rbp + 4] > 5) { jump (BOMB) }`. Dù lệnh nhảy ở đây cho phép số âm đi qua, nhưng toàn bộ số âm đã bị "tiêu diệt" từ chốt 1 nên lớp bảo vệ này chỉ dùng để gọt bớt biên độ giới hạn xuống mức 5.

=> **Kết luận:** Điều kiện sinh tử là Input 1 phải là số nguyên dương hợp lệ nằm trong đoạn **[0, 5]**. (Số `0` hoàn toàn hợp lệ vì vượt qua cả 2 bài test).

## 3. Lệnh nhảy gián tiếp (The Jump Table)
Trung tâm của thuật toán nằm ở đoạn mã:
```c
rax = [rbp + 134];
rcx = 00007ff7`675c0000;
eax = [rcx + rax*4 + 122CC];
rax += rcx;
jmp rax;
```
Chương trình sử dụng số thứ nhất để tính toán ra một địa chỉ bộ nhớ, sau đó thực hiện lệnh nhảy gián tiếp `jmp rax` đến địa chỉ đó. Đây chính là cách Assembly biên dịch cấu trúc `switch-case`. Tùy thuộc vào việc Input 1 bằng `0, 1, 2, 3, 4, 5` mà chương trình sẽ nhảy đến các "case" tương ứng. 

Mỗi "case" chứa một loạt các phép tính cộng/trừ liên hoàn (ví dụ: `eax -= 7E;`, `eax += 7E;`) làm biến đổi giá trị của biến `[rbp + 44]`.

## 4. Khớp số thứ hai (Matching Second Input)
Thay vì ngồi tính tay đống phép toán rườm rà, chúng ta dùng phương pháp **Phân tích động (Dynamic Analysis)**: Đặt breakpoint ở cuối đoạn switch-case và đọc kết quả cuối cùng.

Giả sử nhập Input 1 = `3`. Sau khi lệnh `jmp rax` chạy xong hàng loạt phép toán, giá trị của `[rbp + 44]` trở thành `0xffffff82` (hệ Hex).
Dùng quy tắc số bù 2 (Two's complement) để dịch ngược `0xffffff82` sang số thập phân có dấu, ta được kết quả là `-126`.

Cuối cùng, chương trình nạp số thứ hai vào `eax = [rbp + 24]` và kiểm tra điều kiện chốt hạ `if([rbp + 44] == eax)`. Nếu Input 2 bằng đúng kết quả đã tính toán, bom sẽ được vô hiệu hóa (`jump PASSSSSS`).

👉 **Answer (Phase 3):** Có nhiều đáp án đúng tùy thuộc vào Input 1 (từ 0 đến 5). Ví dụ:
* `1 -26`
* `3 -126`
