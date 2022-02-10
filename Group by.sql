--Hàm aggregate funtion: 
--Min: tính giá trị nhỏ nhất 
--Max: tính giá trị lớn nhất 
--Avg: tính giá trị trung bình 
--Count: đếm số lượng 
--Sum: tính tổng 

--Select max(…) -- thuộc tính, biểu thức nằm trong ngoặc 
--From …. 


-- Tính giá nhỏ nhất trong bảng Product
select Min(Price) as Price 
from Products

-- Đếm số lượng sản phẩm trong bảng Product 
select count(ProductCode) 
from Products

-- Tìm ngày của hóa đơn đầu tiên của khách hàng Nguyễn Thị Bé
select top 1 Date 
from Orders inner join Customers on Orders.CustomerID = Customers.CustomerID
where Name = N'Nguyễn Thị Bé' 
Order by Date asc

-- Tìm ProductCode, ProductName của sản phẩm có giá nhỏ nhất 
-- Tìm ProductCode, ProductName của sản phẩm có Price lớn hơn Price trung 
-- bình của các sản phẩm trong Products 

select ProductCode,ProductName = Products.Name
from Products
where Price > (
select avg(Price)
from Products)

-- Tìm ProductCode, ProductName của sản phẩm được mua với Quantity 
-- lớn nhất trong một hóa đơn 
select Products.ProductCode,ProductName = Products.Name
from Products join OderItems on Products.ProductCode = OderItems.ProductCode
where Quantity = (
select max(Quantity)
from OderItems
)

-- Tìm số sản phẩm khác nhau mà khách hàng Nguyễn Thị Bé đã mua 
select  count (distinct Products.ProductCode)
from Products inner join OderItems on Products.ProductCode = OderItems.ProductCode 
               inner join Orders on OderItems.OrderID = Orders.OrderID 
			   inner join Customers on Customers.CustomerID = Orders.CustomerID and Customers.Name = N'Nguyễn Thị Bé'
			   
-- Tìm tổng tiền mà khách hàng Nguyễn Thị Bé đã bỏ ra để mua hàng  
-- trong 5/2000 
select sum(SellPrice)
from Customers inner join Orders on Customers.CustomerID = Orders.CustomerID and Customers.Name = N'Nguyễn Thị Bé' 
               inner join OderItems on OderItems.OrderID = Orders.OrderID and MONTH(date) = 5 and YEAR(date) = 2000
              
-- Tìm số khách hàng có địa chỉ Email 

-- GROUP BY 

select CustomerID, count(OrderID) as NumberOfOrders 
from Orders 
group by CustomerID 

-- Hiển thị CustomerID, Name, NumberOfOrders của từng khách hàng 
select Customers.CustomerID,Name, count(OrderID) as NumberOfOrders 
from Orders inner join Customers on Customers.CustomerID = Orders.CustomerID
group by Customers.CustomerID,Name 
-- 1. Hiển thị CustomerID, Name, Month, Year, NumberOfOrders với NumberOfOrders  
-- là số lượng hóa đơn của từng khách hàng trong từng tháng thuộc từng năm 
select Customers.CustomerID, Name, Month(date) as Month, Year(date) as Year, count(OrderID) as NumberOfOrders 
from Customers inner join Orders on Customers.CustomerID = Orders.CustomerID
Group by  Customers.CustomerID, Name, Month(date) , Year(date)
-- 2. Hiển thị OrderID, Date, TotalAmount với TotalAmount là tổng tiền của từng hóa đơn  
select Orders.OrderID, Date, sum(SellPrice) as TotalAmount 
from Orders join OderItems on Orders.OrderID = OderItems.OrderID
group by Orders.OrderID, Date 

-- 3. Hiển Thị ProductCode, ProductName, TotalQuantity, NumberOfOrders, TotalAmount 
-- của từng sản phẩm với TotalQuantity là tổng số lượng đã bán của sản phẩm 
-- NumberOfOrders là số lượng hóa đơn đã mua của từng sản phẩm 
-- TotalAmount là tổng tiền thu được từ việc bán từng sản phẩm 
select Products.ProductCode,Products.Name as ProductName, sum(Quantity) TotalQuantity, 
       count(Orders.OrderID) as NumberOfOrders, sum(SellPrice) as TotalAmount
from Products join OderItems on Products.ProductCode = OderItems.ProductCode 
              join Orders on OderItems.OrderID = Orders.OrderID
group by Products.ProductCode,Products.Name 

-- 4. Hiển thị CustomerID, CustomerName, NumberOfOrders, TotalAmount của từng khách 
-- hàng với: 
-- NumberOfOrders: là số hóa đơn của khách hàng 
-- TotalAmount là tổng tiền mà từng khách hàng đã bỏ ra để mua hàng 
-- Sắp xếp kết quả trả về giảm dần theo TotalAmount 
select Customers.CustomerID, Customers.Name as CustomerName, count(distinct OderItems.OrderID) as NumberOfOrders,sum(Quantity*SellPrice) as TotalAmount 
from Customers join Orders on Customers.CustomerID = Orders.CustomerID 
               inner join OderItems on Orders.OrderID = OderItems.OrderID
Group by Customers.CustomerID, Customers.Name  
Order by TotalAmount desc

-- Hiển thị cả khách hàng chưa mua hàng 
select Customers.CustomerID, Customers.Name as CustomerName, count(distinct OderItems.OrderID) as NumberOfOrders, isnull (sum(Quantity*SellPrice),0) as TotalAmount 
from Orders join OderItems on Orders.OrderID = OderItems.OrderID 
right join Customers on Customers.CustomerID = Orders.CustomerID
Group by Customers.CustomerID, Name 
order by TotalAmount desc 

-- 5. Hiển thị CustomerID, CustomerName, ProductCode, ProductName, TotalQuantity,  
-- TotalAmount, NumberOfOrders tương ứng với từng khách hàng và từng sản phẩm mà 
-- khách hàng đã mua: 
-- TotalQuantity là tổng số lượng của từng sản phẩm mà khách hàng đã mua 
-- TotalAmount là tổng số tiền mà từng khách hàng đã bỏ ra để mua từng sản phẩm 
-- NumberOfOrders là tổng số hóa đơn mà từng khách hàng đã mua từng sản phẩm 
-- Sắp xếp kết quả trả về tăng dần theo CustomerID, giảm dần theo TotalAmount 
select Customers.CustomerID, Customers.Name as CustomerName,Products.ProductCode,Products.Name as ProductName,
sum (Quantity) as TotalQuantity,sum (Quantity*SellPrice) as TotalAmount, count(distinct Orders.OrderID) as NumberOfOrders
from Customers join Orders on Customers.CustomerID = Orders.CustomerID 
               join OderItems on Orders.OrderID = OderItems.OrderID
			   join Products on Products.ProductCode = OderItems.ProductCode
Group by Customers.CustomerID, Customers.Name ,Products.ProductCode,Products.Name 
Order by Customers.CustomerID asc, TotalAmount desc

-- 6. Hiển thị thông tin của hóa đơn có tổng tiền cao nhất trong từng tháng với các thuộc tính sau: 
-- Month, Year, OrderID, Date, TotalAmount. Sắp xếp kết quả trả về tăng dần theo Year, Month
with t as (
select date, sum(SellPrice*Quantity) as TotalAmount 
from  Orders join OderItems on Orders.OrderID = OderItems.OrderID 
group by  Orders.OrderID, Date 
)
select Month(date) as Month,YEAR(date) as Year, Orders.OrderID, Date,sum(SellPrice*Quantity) as TotalAmount 
from t
where TotalAmount in (
select max(TotalAmount) 
from t 
group by date)
order by Year asc , Month asc

--
with t as (select MONTH(Date) as Month, year(Date) as Year, Orders.OrderID, Date,  
sum(SellPrice*Quantity) as TotalAmount 
from Orders join OderItems on Orders.OrderID = OderItems.OrderID 
group by MONTH(Date), year(Date), Orders.OrderID, Date) 
select * 
from t t1 
where TotalAmount = ( 
select max(TotalAmount) 
from t t2 
where t2.Month = t1.Month and t2.Year = t1.Year 
) 
order by YEAR asc, Month asc 

-- Hiển thị CustomerID, CustomerName, NumberOfOrders, TotalAmount của từng khách 
-- hàng với: 
-- NumberOfOrders: là số hóa đơn của khách hàng 
-- TotalAmount là tổng tiền mà từng khách hàng đã bỏ ra để mua hàng 
-- Sắp xếp kết quả trả về giảm dần theo TotalAmount 
-- hiển thị cả khách hàng chưa mua hàng 
-- chỉ hiển thị những dòng có TotalAmount < 2000 
select Customers.CustomerID, Customers.Name as CustomerName, 
count(distinct Orders.OrderID) as NumberOfOrders, isnull (sum(SellPrice*Quantity),0) as TotalAmount 
from Customers  join Orders on Customers.CustomerID = Orders.CustomerID 
                right join OderItems on Orders.OrderID = OderItems.OrderID
group by  Customers.CustomerID, Customers.Name 
having  sum(SellPrice*Quantity) < 2000
order by TotalAmount desc

-- điều kiện trong WHERE được kiểm tra trước khi group by nên không kiểm tra được các 
-- aggregate function trong where 
-- điều kiện trong having được kiểm tra sau khi group by nên kiểm tra được các điều kiện 
-- theo nhóm, có thể dùng các hàm aggregate function 

--Cú pháp select: 
--select thuộc tính, biểu thức 
--from các bảng join với nhau 
--where điều kiện để chọn ra các dòng tạo thành trong from 
--group by các thuộc tính, biểu thức xác định nhóm 
--having điều kiện kiểm tra sau group by 
--order by thuộc tính, biểu thức 

-- 7. Hiển thị thông tin CustomerID, CustomerName, NumberOfOrders, TotalAmount của từng khách hàng trong 5/2000. Yêu cầu hiển thị cả thông tin của các khách hàng không có hóa đơn trong 5/2000. 
-- 8. Hiển thị thông tin ProductCode, ProductName, TotalQuantity, TotalAmount của từng sản phẩm. Với TotalQuantity và TotalAmount lần lượt là tổng số lươợng và tổng tiền thu được của từng sản phẩm trong 5/2000.
-- Hiển thị cả thông tin của các sản phẩm không bán được trong 5/2000 
-- 9. Hiển thị CustomerID, CustomerName, ProductCode, ProductName, TotalQuantity, TotalAmount, NumberOfOrders với TotalQuantity, TotalAmount, NumberOfOrders lần lượt là tổng số lượng, tổng tiền, 
-- số lượng hóa đơn mà từng khách hàng đã mua đối với từng sản phẩm. Chỉ hiển thị những dòng có TotalAmount > 3000 hoặc NumberOfOrders > 2 
-- 10. Hiển thị OrderID, Date, TotalAmount của các hóa đơn có TotalAmount lớn hơn trung biình TotalAmount của tất cả các hóa đơn 
-- 11. Hiển thị OrderID, Date, TotalAmount của hóa đơn có TotalAmount lớn nhất và TotalAMount nhỏ nhất. 
