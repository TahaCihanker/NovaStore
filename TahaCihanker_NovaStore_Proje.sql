-- =====================================================================
-- NovaStore E-Ticaret Veri Yönetim Sistemi
-- Hazırlayan : Taha Cihanker
-- Platform   : Microsoft SQL Server
-- =====================================================================


-- BÖLÜM 1: VERİ TABANI TASARIMI (DDL)

-- Bölüm 1 - Görev 1: Veri tabanının oluşturulması
CREATE DATABASE NovaStoreDB;
GO

USE NovaStoreDB;
GO

-- Bölüm 1 - Görev 2A: Categories (Kategoriler) tablosu
CREATE TABLE Categories (
    CategoryID   INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName VARCHAR(50) NOT NULL
);
GO

-- Bölüm 1 - Görev 2C: Customers (Müşteriler) tablosu
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName   VARCHAR(50),
    City       VARCHAR(20),
    Email      VARCHAR(100) UNIQUE
);
GO

-- Bölüm 1 - Görev 2B: Products (Ürünler) tablosu
CREATE TABLE Products (
    ProductID   INT IDENTITY(1,1) PRIMARY KEY,
    ProductName VARCHAR(100) NOT NULL,
    Price       DECIMAL(10,2),
    Stock       INT DEFAULT 0,
    CategoryID  INT FOREIGN KEY REFERENCES Categories(CategoryID)
);
GO

-- Bölüm 1 - Görev 2D: Orders (Siparişler) tablosu
CREATE TABLE Orders (
    OrderID     INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID  INT FOREIGN KEY REFERENCES Customers(CustomerID),
    OrderDate   DATETIME DEFAULT GETDATE(),
    TotalAmount DECIMAL(10,2)
);
GO

-- Bölüm 1 - Görev 2E: OrderDetails (Sipariş Detayları - Ara Tablo)
CREATE TABLE OrderDetails (
    DetailID  INT IDENTITY(1,1) PRIMARY KEY,
    OrderID   INT FOREIGN KEY REFERENCES Orders(OrderID),
    ProductID INT FOREIGN KEY REFERENCES Products(ProductID),
    Quantity  INT
);
GO


-- BÖLÜM 2: VERİ GİRİŞİ (DML - INSERT)

-- Bölüm 2 - Görev 1: 5 adet kategori
INSERT INTO Categories (CategoryName) VALUES
('Elektronik'),
('Giyim'),
('Kitap'),
('Kozmetik'),
('Ev ve Yaşam');
GO

-- Bölüm 2 - Görev 2: Her kategoriye ait olacak şekilde 12 ürün
INSERT INTO Products (ProductName, Price, Stock, CategoryID) VALUES
('Kablosuz Kulaklık',   1499.90,  35, 1),
('Akıllı Saat',         3299.00,  12, 1),
('Bluetooth Hoparlör',   899.50,  18, 1),
('Erkek Kot Pantolon',   749.90,  40, 2),
('Kadın Trençkot',      1899.00,   8, 2),
('Pamuklu Tişört',       249.90, 120, 2),
('Suç ve Ceza',          189.00,  60, 3),
('Sefiller',             219.50,  15, 3),
('Nemlendirici Krem',    329.90,  25, 4),
('Parfüm 50 ml',        1250.00,   5, 4),
('Seramik Kupa Seti',    459.00,  30, 5),
('Masa Lambası',         599.90,  19, 5);
GO

-- Bölüm 2 - Görev 3: 6 adet müşteri
INSERT INTO Customers (FullName, City, Email) VALUES
('Ahmet Yılmaz',  'İstanbul',  'ahmet.yilmaz@example.com'),
('Ayşe Demir',    'Ankara',    'ayse.demir@example.com'),
('Mehmet Kaya',   'İzmir',     'mehmet.kaya@example.com'),
('Zeynep Çelik',  'Bursa',     'zeynep.celik@example.com'),
('Mustafa Şahin', 'Antalya',   'mustafa.sahin@example.com'),
('Elif Arslan',   'Eskişehir', 'elif.arslan@example.com');
GO

-- Bölüm 2 - Görev 4 (a): Farklı tarihlerde yapılmış 10 sipariş
INSERT INTO Orders (CustomerID, OrderDate, TotalAmount) VALUES
(1, '2026-09-05T10:15:00', 1877.90),
(2, '2026-09-12T14:30:00', 2228.90),
(3, '2026-09-20T09:45:00', 3299.00),
(1, '2026-10-02T19:20:00', 1208.70),
(4, '2026-10-08T11:05:00', 1469.50),
(5, '2026-10-15T16:40:00', 1799.00),
(2, '2026-10-23T13:10:00', 2099.70),
(6, '2026-11-01T20:55:00',  848.80),
(3, '2026-11-07T08:30:00', 1099.70),
(1, '2026-11-12T15:00:00', 1250.00);
GO

-- Bölüm 2 - Görev 4 (b): Siparişlere ait sipariş detayları
INSERT INTO OrderDetails (OrderID, ProductID, Quantity) VALUES
(1,  1,  1),
(1,  7,  2),
(2,  5,  1),
(2,  9,  1),
(3,  2,  1),
(4,  11, 1),
(4,  6,  3),
(5,  10, 1),
(5,  8,  1),
(6,  3,  2),
(7,  4,  2),
(7,  12, 1),
(8,  7,  1),
(8,  9,  2),
(9,  12, 1),
(9,  6,  2),
(10, 10, 1);
GO


-- BÖLÜM 3: SORGULAMA VE ANALİZ (DQL - SELECT ve JOINS)

-- Bölüm 3 - Soru 1: Temel Listeleme
SELECT ProductName, Stock
FROM Products
WHERE Stock < 20
ORDER BY Stock DESC;
GO

-- Bölüm 3 - Soru 2: Veri Birleştirme (INNER JOIN)
SELECT c.FullName    AS MusteriAdi,
       c.City        AS Sehir,
       o.OrderDate   AS SiparisTarihi,
       o.TotalAmount AS ToplamTutar
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID;
GO

-- Bölüm 3 - Soru 3: Çoklu Birleştirme ve Detay Raporu
SELECT p.ProductName   AS UrunAdi,
       p.Price         AS Fiyat,
       cat.CategoryName AS Kategori
FROM Customers c
INNER JOIN Orders o        ON c.CustomerID  = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID     = od.OrderID
INNER JOIN Products p      ON od.ProductID  = p.ProductID
INNER JOIN Categories cat  ON p.CategoryID  = cat.CategoryID
WHERE c.FullName = 'Ahmet Yılmaz';
GO

-- Bölüm 3 - Soru 4: Gruplama ve Aggregate Fonksiyonlar
SELECT cat.CategoryName   AS Kategori,
       COUNT(p.ProductID) AS UrunSayisi
FROM Categories cat
LEFT JOIN Products p ON cat.CategoryID = p.CategoryID
GROUP BY cat.CategoryName;
GO

-- Bölüm 3 - Soru 5: Ciro Analizi
SELECT c.FullName         AS MusteriAdi,
       SUM(o.TotalAmount) AS ToplamCiro
FROM Customers c
INNER JOIN Orders o ON c.CustomerID = o.CustomerID
GROUP BY c.FullName
ORDER BY ToplamCiro DESC;
GO

-- Bölüm 3 - Soru 6: Zaman Analizi
SELECT OrderID,
       OrderDate                              AS SiparisTarihi,
       DATEDIFF(DAY, OrderDate, GETDATE())    AS GecenGunSayisi
FROM Orders;
GO


-- BÖLÜM 4: İLERİ SEVİYE VERİ TABANI NESNELERİ

-- Bölüm 4 - Görev 1: View (Görünüm) oluşturma
CREATE VIEW vw_SiparisOzet AS
SELECT c.FullName    AS MusteriAdi,
       o.OrderDate   AS SiparisTarihi,
       p.ProductName AS UrunAdi,
       od.Quantity   AS Adet
FROM Customers c
INNER JOIN Orders o        ON c.CustomerID = o.CustomerID
INNER JOIN OrderDetails od ON o.OrderID    = od.OrderID
INNER JOIN Products p      ON od.ProductID = p.ProductID;
GO

-- Bölüm 4 - Görev 1: View'ın kullanımı
SELECT * FROM vw_SiparisOzet;
GO

-- Bölüm 4 - Görev 2: Yedekleme (Backup)
BACKUP DATABASE NovaStoreDB
TO DISK = 'C:\Yedek\NovaStoreDB.bak';
GO
