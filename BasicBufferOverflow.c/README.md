# Challenge Description

![Picture 1](./images/BBO_pic1.jfif)

![Picture 2](./images/BBO_pic2.jfif)

- Mục tiêu của bài này là làm sao cho tại điều kiện của main hàm lame() hoặc lame2() phải trả về 0 để có thể kích hoạt hàm AwesomeSauce(), bằng cách khai thác lỗ hổng tràn bộ nhớ.

## A. INPUT

<p align="center">
  <img src="./images/BBO_pic3.jfif" width="48%" />
  <img src="./images/BBO_pic4.jfif" width="48%" />
</p>

- Đầu tiên bạn có thể thấy được chương trình sẽ gán input đầu vào của mình vào argv[1] và argv[2], nếu bạn thắc mắc thì argv[0] của chúng ta có thể là ./BasicBuffOverflow.exe input1 input2!! Ta chắc chắn rằng input đầu vào phải là 2 số và chạy bằng cách điền như ảnh bên phải.
- Ảnh trái ta có thể thấy được input mình điền vào được lưu dưới dạng string nó sẽ dùng lệnh `_strtoi64` để chuyển thành `int` :

  `size = _strtoi64(argv[1], "", 10);
	value = _strtoi64(argv[2], "", 16);`

- Bạn có thể thấy rằng input1 sẽ được máy tính nhận đầu vào là hệ cơ số 10 để đổi sang decimal rồi lưu vào biến size, tương tự input2 đầu vào là hệ cơ số 16 đổi sang decimal tiếp tục lưu vào value!!!
- VD: `2 10` -> `size = 2, value = 16`.

## B. Lame() and Lame2()

- Để giải bài này ta phải phân tích bằng cách soi assembly của các câu lệnh và vẽ Stack để quan sát !!! (Bài này Xeno vẫn đang test trên các công cụ Debugger nên tạm thời tôi sẽ làm trên VisualStudio)

![Picture 5](./images/BBO_pic5.jfif)

Đầu tiên chương trình với hàm `main(unsigned int argc, char** argv)` argc là số lượng tham số sẽ được lưu vào thanh ghi `rcx` và `rdx` sẽ lưu địa chỉ bắt đầu chuỗi ta đã nhập, sau đó là câu lệnh `sub rsp,38h` lúc này Stack của chúng ta có dạng:

![Picture 6](./images/BBO_pic6.jfif)

<p align="center">
  <img src="./images/BBO_pic7.jfif" width="48%" />
  <img src="./images/BBO_pic8.jfif" width="48%" />
</p>

tiếp theo dựa vào 2 ảnh ta có thể thấy rằng input1 và input2 lần lượt được lưu vào `[rsp + 28h]` và `[rsp + 20h]` lúc này stack có dạng: 

![Picture 8a](./images/BBO_pic8a.jfif)

---

![Picture 9](./images/BBO_pic9.png)

Như các bạn đã thấy các chỗ tôi đánh dấu trong ảnh lần lượt là câu lệnh gọi hàm lame(), lame2() và một địa chỉ lệnh thực hiện hàm AwesomeSauce()
Khi step into vào lệnh gọi hàm call lần 1, RET sẽ được lưu vào `15FDF8`.

![Picture 10](./images/BBO_pic10.jfif)

Trong hàm lame(), rcx tức giá trị input2 được gán vào `[15FDF8 + 8] = 15FE00` và `sub rsp, 0A8h` => rsp = 15FD50.
Tiếp theo là hàng loạt lệnh gán value = 4 vào các địa chỉ, để ý array2[3] được lưu vào `[rsp + 18h + 20h] = [15FD88]`
=> Từ đây ta suy luận được rằng array2[0], array2[1], array2[2], array[3] được lưu lần lượt vào `[15FD70], [15FD78], [15FD80], [15FD88]`.

![Picture 11](./images/BBO_pic11.jfif)

