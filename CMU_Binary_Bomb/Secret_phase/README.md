# Secret_phaseeeeeeeeeeeeeeeeee !!!!!!

## Search for the call to secret_phase

Normally, after you solve a phase, you will see a call to the phase_defused function. At this point, you might think that once the phase is solved, this function is simply called to print a message saying that you have successfully defused the phase. However, if you are curious and go inside the function and scroll down, you will see a call to secret_phase, which we can never seem to trigger. At this point, you need to analyze the phase_defused function.

![Picture 1](./images/secret_phase_pic1.jfif)

Ban đầu chương trình sẽ kiểm tra liệu mình có trả lời đủ 6 phase hay chưa nếu chưa thì nó nhảy ra ngoài hàm phase_defused và thực hiện các phase khác.
![Picture 2](./images/secret_phase_pic2.jfif)

Tại địa chỉ `00007ff7`675d2cd1` bạn sẽ gặp câu lệnh `lea rcx,[bomb!input_strings (00007ff7`675e0200)]`, khi check thử địa chỉ rcx vừa được gán ta thấy nó chứa chuỗi đáp án của phase1 ta đã nhập. Tiếp theo nếu bạn để ý rcx += rax, lúc này các bạn check thử thanh ghi rcx thì phát hiện ra nó di chuyển đến địa chỉ giữ chuỗi đáp án của phase 4!!!
Cuối cùng ở địa chỉ `00007ff7`675d2cf2` là câu lệnh `lea rdx,[bomb!`string' (00007ff7`675dc520)]`, tiếp tục soi địa chỉ này thì ta thấy được input đầu vào tại phase4 của mình phải có dạng "%d %d %s".
-> Điều này chứng tỏ tại phase4 khi điền 2 số đáp án, đằng sau phải có thêm một chuỗi nào đó để kích hoạt!!!!

![Picture 3](./images/secret_phase_pic3.jfif)
Tiếp theo là câu lệnh call sscanf để kiểm tra xem input của mình có đủ 3 tham số như format ở trên không và địa chỉ `00007ff7`675d2d10` bạn sẽ lại thấy rdx được gán một chuỗi gì đó qua câu lệnh `rdx,[bomb!`string' (00007ff7`675dc52c)]` soi địa chỉ này -> ta thấy rdx đang nắm giữ chuỗi "DrEvil"!!!! và ngay sau đó rcx được gán một địa chỉ nào đó và khi soi thì thấy thanh ghi này chứa một chuỗi - tham số thứ 3 trong input của mình. 
![Picture 4](./images/secret_phase_pic4.jfif)
Theo sau đó là câu lệnh so sánh để kiểm tra liệu tham số thứ 3 của mình có phải "DrEvil" hay không, nếu sai nó sẽ nhảy tới địa chỉ *00007ff7 675d2d41* và ta không thể nào vào được hàm call secret_phase :(((

-> Tóm lại điều kiện để vào được secret_phase là tại phase 4 đáp án phải là `3 10 "DrEvil"` !!!!!!
