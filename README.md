# AI Lead Generation & CRM System – Test Documentation

This README documents the necessary steps and test cases required to validate key features of the AI Lead Generation and CRM platform.

## 📌 Setup Instructions

You may need to cover:

- **Ruby version:** *Specify version if applicable*
- **System dependencies:** *List required packages or services*
- **Configuration:** `.env` setup, API keys, etc.
- **Database creation:** `rails db:create` or equivalent
- **Database initialization:** `rails db:seed`
- **Running the test suite:** `rspec`, `yarn test`, etc.
- **Services used:** Background jobs, Redis, ElasticSearch, etc.
- **Deployment instructions:** Heroku, Docker, etc.

---

## Test Cases

---

### **TC_AI_001: Tự động crawl và phân tích dữ liệu công ty từ nhiều nguồn**

**Precondition:**  
- Hệ thống đã kết nối thành công với các nguồn dữ liệu như LinkedIn, Crunchbase và website công ty.  
- Người dùng đã đăng nhập với quyền được sử dụng tính năng AI Lead Generation.

**Test Steps:**
1. Đăng nhập vào hệ thống.
2. Truy cập module “Crawl Data Sources”.
3. Click vào nút “Add Source”.
4. Hệ thống tự động crawl và AI phân tích dữ liệu từ các nguồn.
5. Hệ thống hiển thị thông tin như ngành nghề, quy mô, tình trạng tuyển dụng...

**Expected Result:**
- Dữ liệu hiển thị đầy đủ từ nhiều nguồn.
- Thông tin phân tích rõ ràng, chính xác.
- Hiển thị danh sách công ty mới gọi vốn hoặc đang mở rộng.

---

### **TC_AI_002: Trích xuất người ra quyết định từ thông tin công ty**

**Precondition:**  
- Danh sách công ty tiềm năng đã được crawl thành công.

**Test Steps:**
1. Truy cập chi tiết một công ty từ danh sách.
2. Hệ thống trích xuất thông tin từ profile công khai.
3. Xác định tên, chức vụ, email của decision-makers.
4. Hiển thị danh sách lead.
5. Thêm lead được chọn.

**Expected Result:**
- Hiển thị đúng tên, chức vụ, email của CTO, CEO, Product Manager…
- Ưu tiên người có quyền quyết định cao.
- Phân tích điểm tiềm năng rõ ràng.

---

### **TC_AI_003: Tạo nội dung email tự động dựa trên thông tin công ty**

**Precondition:**  
- Có ít nhất một công ty được chọn trong danh sách khách hàng tiềm năng.

**Test Steps:**
1. Truy cập trang “Email Outreach”.
2. Chọn công ty cụ thể.
3. Chọn tone văn phong (ví dụ: profesional).
4. Click “Optimal AI”.
5. Click “Send now”.

**Expected Result:**
- Email được sinh tự động phù hợp ngành nghề, người nhận.
- Văn phong đúng với lựa chọn.
- Có thể chỉnh sửa trước khi gửi.

---

### **TC_AI_004: Ghi nhận và hiển thị các chỉ số email**

**Precondition:**  
- Email đã được gửi từ hệ thống.

**Test Steps:**
1. Truy cập màn hình “Email Outreach”.
2. Quan sát các chỉ số: mở, click, trả lời.
3. Xem gợi ý follow-up nếu chưa có phản hồi.

**Expected Result:**
- Thống kê đúng số lượt mở, click, trả lời.
- Hiển thị gợi ý hành động tiếp theo nếu không có phản hồi.

---

### **TC_CRM_001: Cập nhật trạng thái pipeline bằng cách kéo thả**

**Precondition:**  
- Có ít nhất 1 khách hàng ở trạng thái “New lead”.

**Test Steps:**
1. Truy cập CRM → Kanban View.
2. Kéo thả lead để thay đổi trạng thái.
3. Quan sát cập nhật.

**Expected Result:**
- Trạng thái lead được cập nhật đúng.
- Giao diện phản hồi ngay lập tức.
- Thao tác được lưu lại và cập nhật cho tất cả user.
- AI gợi ý hành động tiếp theo.

---

### **TC_DOC_001: Tạo proposal tự động dựa trên yêu cầu khách hàng**

**Precondition:**  
- Khách hàng đã để lại yêu cầu cụ thể.

**Test Steps:**
1. Truy cập module Proposal Generator.
2. Chọn khách hàng từ danh sách.
3. Xác nhận yêu cầu.
4. Hệ thống điền dữ liệu vào mẫu proposal.
5. Click "AI optimize".
6. Tùy chỉnh case study, báo giá.

**Expected Result:**
- Proposal được tạo chính xác và đầy đủ.
- Có thể chỉnh sửa trước khi xuất.
- Xuất file PDF chuẩn.

---

### **TC_DOC_002: Phân tích hành vi khi khách hàng xem proposal**

**Precondition:**  
- Proposal đã được gửi cho khách hàng qua hệ thống.

**Test Steps:**
1. Truy cập trang “Proposal Tracking”.
2. Chọn proposal đã gửi.
3. Xem thời gian mở, số lần xem, phần nội dung được xem lâu nhất.

**Expected Result:**
- Hiển thị phân tích hành vi người xem.
- Đưa ra gợi ý follow-up tùy theo hành vi khách hàng.

---

## 5. Quản lý team & phối hợp làm việc

---

### **TC_TEAM_001: Phân quyền theo vai trò trong hệ thống**

**Precondition:**  
- Hệ thống đã có tài khoản và các vai trò: Quản lý, Sales Support.

**Test Steps:**
1. Đăng nhập với tài khoản Quản lý.
2. Truy cập trang “Quản lý người dùng”.
3. Theo dõi vai trò của từng tài khoản.
4. Đăng nhập bằng Admin và Sale Support để kiểm tra quyền.

**Expected Result:**
- Tài khoản chỉ truy cập được tính năng phù hợp với vai trò.
- Các chức năng bị giới hạn đúng theo phân quyền.

---


### **TC_TEAM_002: Ghi nhận hiệu suất làm việc của từng thành viên**

**Precondition:**  
- Thành viên đã thực hiện các tác vụ liên quan đến lead.

**Test Steps:**
1. Truy cập module “Báo cáo hiệu suất”.
2. Xem báo cáo cá nhân theo thời gian.

**Expected Result:**
- Hiển thị số lượng lead xử lý, số deal chốt.
- Dữ liệu cập nhật theo ngày/tuần/tháng.

---

### **TC_TEAM_003: Báo cáo tổng quan tiến độ và hiệu quả làm việc của team**

**Precondition:**  
- Các thành viên đã hoàn thành nhiệm vụ trong hệ thống.

**Test Steps:**
1. Truy cập module “Báo cáo tổng quan”.
2. Xem thống kê tổng thể theo thời gian.

**Expected Result:**
- Hiển thị bảng tổng hợp: công việc giao, hoàn thành, đang xử lý.
- Giao diện đơn giản, dễ hiểu.
- Có biểu đồ hoặc bảng tóm tắt hiệu quả.


