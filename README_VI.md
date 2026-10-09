# 💻 x86-64 Reverse Engineering Labs

### 🔍 Những bài phân tích của tôi | Học hỏi, khám phá điểm yếu và thấu hiểu.

> 💡 **Đừng chỉ dừng lại ở những câu lệnh, hãy hiểu logic đằng sau chúng.**

## 🚀 Giới thiệu Repository

👋 Chào mừng bạn đến với góc nhỏ của tôi trong thế giới Reverse Engineering!

Repository này ghi lại hành trình học tập của tôi về **Assembly x86-64**, **Windows Internals**, **Reverse Engineering** và **Binary Exploitation**.

Tại đây, tôi chia sẻ những **ghi chú kỹ thuật (Technical Notes)** và **bài phân tích thực hành (Lab Write-ups)** trong quá trình khám phá cách chương trình hoạt động ở cấp độ thấp, cách luồng điều khiển được tổ chức, cách các lỗ hổng xuất hiện và cách hiểu hành vi của chương trình thông qua phân tích.

Và có vài chỗ tôi còn để tiếng mẹ đẻ của tôi nên các bạn thông cảm, tôi sẽ dịch nó sang tiếng anh trong tương lai gần kkk.

### 🎯 Các lĩnh vực tôi quan tâm

- 🖥️ **x86-64 Assembly** — Tìm hiểu các câu lệnh cấp thấp, thanh ghi, bộ nhớ và quá trình thực thi chương trình.
- 🪟 **Windows Internals** — Khám phá các cơ chế hoạt động bên trong hệ điều hành Windows.
- 🔍 **Reverse Engineering** — Phân tích file thực thi, tìm hiểu luồng điều khiển và khám phá logic chương trình.
- 🛠️ **Debugging & Binary Analysis** — Làm việc với debugger, stack frame, cấu trúc bộ nhớ và file thực thi.
- 💥 **Binary Exploitation & Exploit Development** — Tìm hiểu các lỗ hổng liên quan đến lỗi bộ nhớ, những kỹ thuật khai thác và cách các điểm yếu phần mềm có thể bị khai thác trong môi trường được kiểm soát.
- 🐛 **Vulnerability Research** — Nghiên cứu lỗ hổng phần mềm, tìm hiểu nguyên nhân gốc rễ và những tác động tiềm ẩn đến bảo mật.
- 🦠 **Malware Analysis** — Một lĩnh vực hấp dẫn mà tôi hy vọng sẽ có cơ hội tìm hiểu sâu hơn trong tương lai.

---

## 📚 Có gì bên trong Repository?

Repository này bao gồm:

- 📝 **Technical Notes:** Các khái niệm, lời giải thích và những phát hiện thú vị trong quá trình học tập.
- 🧩 **Lab Write-ups:** Các bài phân tích thực hành từng bước, bao gồm cách tiếp cận, quá trình suy luận và lời giải của tôi.
- ⚙️ **Assembly Analysis:** Tìm hiểu các câu lệnh, luồng điều khiển, cách truy cập bộ nhớ và hành vi chương trình.
- 💣 **Binary Exploitation Labs:** Khám phá các lỗ hổng bộ nhớ, khái niệm khai thác và phát triển exploit thông qua các bài thực hành.
- 💭 **Personal Insights:** Những quan sát, giả thuyết, sai lầm và bài học mà tôi tích lũy được trong suốt quá trình.

Tôi không chỉ muốn ghi lại những đáp án cuối cùng.

**✨ Tôi muốn ghi lại cách mình đã tìm ra những đáp án đó.**

---

## 🧠 Triết lý học tập của tôi

Một trong những người truyền cảm hứng lớn nhất cho tôi là **Xeno Kovah**, đặc biệt là những bài giảng của ông về Assembly, kiến trúc máy tính và Reverse Engineering thông qua OpenSecurityTraining.

Một bài học luôn đọng lại trong tôi là tầm quan trọng của việc nhìn nhận bức tranh tổng thể, thay vì đắm chìm vào từng câu lệnh Assembly riêng lẻ.

**🔎 Reverse Engineering không chỉ đơn thuần là đọc mã Assembly.**

Mà còn là quá trình đặt ra những câu hỏi đúng đắn:

- ❓ **Chương trình này thực sự làm gì?**
- 🔍 **Tại sao nó lại hoạt động theo cách đó?**
- ⚙️ **Luồng điều khiển của nó vận hành như thế nào?**
- 🧪 **Điều gì xảy ra nếu chúng ta thay đổi input?**
- 🐛 **Những lỗ hổng có thể tồn tại ở đâu và tại sao?**
- 🧩 **Làm thế nào để hiểu được logic ẩn sau một file thực thi?**

Đôi khi, việc hiểu tại sao chương trình đi theo một nhánh thực thi cụ thể còn quan trọng hơn việc hiểu từng câu lệnh nằm trên nhánh đó.

Tôi cũng bị cuốn hút bởi mối liên hệ giữa **việc hiểu phần mềm hoạt động như thế nào** và **khám phá cách nó có thể gặp lỗi hoặc bị phá vỡ**.

Đối với tôi, Reverse Engineering và Binary Exploitation là hai cách tiếp cận có mối quan hệ mật thiết để khám phá cùng một vấn đề:

**Điều gì thực sự diễn ra bên dưới bề mặt của một chương trình?**

Mục tiêu của tôi là tiếp tục học hỏi, đặt câu hỏi, thử nghiệm và từng bước phát triển sự hiểu biết sâu sắc hơn về cách phần mềm hoạt động, cách các lỗ hổng xuất hiện và cách chúng có thể được phân tích.

> 🎯 **Đừng bao giờ đánh mất mục tiêu ban đầu.**

---

## 🌱 Hành trình học tiếng Anh của tôi

Thú thật, **tiếng Anh của tôi vẫn chưa thực sự thành thạo**, đặc biệt là trong việc viết các tài liệu kỹ thuật.

Việc tự viết một bài phân tích kỹ thuật hoàn chỉnh bằng tiếng Anh vẫn là một thử thách khá lớn đối với tôi.

Hiện tại, tôi đang sử dụng các **công cụ AI 🤖** để hỗ trợ dịch những lời giải thích của mình, cải thiện ngữ pháp và diễn đạt ý tưởng một cách rõ ràng hơn bằng tiếng Anh.

Tuy nhiên, tôi không chỉ đơn thuần muốn tạo ra những bài writeup bằng tiếng Anh. Tôi còn muốn học hỏi từ chính quá trình viết chúng.

Mỗi thuật ngữ kỹ thuật mới, mỗi cách diễn đạt chưa quen thuộc và mỗi câu văn được chỉnh sửa đều là một cơ hội để tôi tiến bộ.

**💭 Tôi tin rằng một ngày nào đó, tôi sẽ có thể tự viết những bài phân tích kỹ thuật hoàn toàn bằng tiếng Anh, sử dụng chính ngôn từ của mình mà không còn phải phụ thuộc vào sự hỗ trợ của AI.**

Cho đến khi ngày đó đến, tôi sẽ tiếp tục luyện tập, mắc sai lầm, học hỏi từ chúng và không ngừng tiến về phía trước.

Suy cho cùng, học tiếng Anh và học Reverse Engineering có một điểm chung:

**Sự tiến bộ đến từ lòng tò mò, sự kiên nhẫn và việc luyện tập đều đặn.**

> 🌟 **Có thể không phải hôm nay, cũng chẳng phải ngày mai, nhưng rồi một ngày nào đó tôi sẽ làm được.**

---

## 🚧 Một hành trình vẫn đang tiếp diễn

Tôi vẫn đang trong quá trình học hỏi, vì vậy một số ghi chú và bài phân tích của tôi có thể chứa sai sót, những lời giải thích chưa đầy đủ hoặc những giả thuyết cần tiếp tục được kiểm chứng.

Đó là một phần của quá trình học tập! 🌱

Tôi cố gắng ghi lại những quan sát và suy luận của chính mình, đồng thời tận dụng những nguồn tài nguyên sẵn có, bao gồm cả AI, để cải thiện cách truyền đạt chúng.

Tôi cũng luôn sẵn sàng đón nhận những góp ý về cả nội dung kỹ thuật lẫn cách viết tiếng Anh.

💬 **Mọi ý kiến đóng góp, chỉnh sửa và trao đổi kiến thức đều được chào đón!**

Các bạn có thể ib qua facebook của tui để nêu ý kiến và đóng góp để tôi có thể hoàn thiện hơn nha <3.

Repository này sẽ tiếp tục phát triển khi tôi tích lũy thêm kinh nghiệm và khám phá những lĩnh vực mới trong Reverse Engineering, Binary Exploitation và Malware Analysis.

---

## ❤️ Một lời nhắc nhở nhỏ dành cho bản thân

**Hãy luôn giữ sự tò mò.**

**Đừng sợ mắc sai lầm.**

**Đừng bao giờ ngừng đặt câu hỏi tại sao.**

Và quan trọng nhất...

**Đừng bao giờ quên lý do bạn bắt đầu.** 🚀

---

*💻 Từng câu lệnh một.*

*🧩 Từng bí ẩn một.*

*🌱 Tiến thêm một bước để trở thành phiên bản tốt hơn chính mình của ngày hôm qua.*

### 🔥 Tiếp tục học hỏi. Tiếp tục đặt câu hỏi. Tiếp tục khám phá bằng Reverse Engineering.
