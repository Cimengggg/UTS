-- ==========================================================
-- Interoly Warehouse Management System (gudang) SQL Schema
-- ==========================================================

CREATE DATABASE IF NOT EXISTS `gudang`;
USE `gudang`;

-- 1. Table: personal
CREATE TABLE IF NOT EXISTS `personal` (
  `personal_id` INT AUTO_INCREMENT PRIMARY KEY,
  `nama` VARCHAR(100) NOT NULL,
  `telepon` VARCHAR(25),
  `alamat` TEXT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 2. Table: user
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` INT AUTO_INCREMENT PRIMARY KEY,
  `user_name` VARCHAR(50) UNIQUE NOT NULL,
  `password` VARCHAR(255) NOT NULL,
  `level` VARCHAR(50) NOT NULL DEFAULT 'Warehouse Manager',
  `personal_id` INT,
  FOREIGN KEY (`personal_id`) REFERENCES `personal`(`personal_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Table: barang_category
CREATE TABLE IF NOT EXISTS `barang_category` (
  `category_id` INT AUTO_INCREMENT PRIMARY KEY,
  `category_name` VARCHAR(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 4. Table: supplier
CREATE TABLE IF NOT EXISTS `supplier` (
  `supplier_id` INT AUTO_INCREMENT PRIMARY KEY,
  `supplier_name` VARCHAR(150) NOT NULL,
  `telepon` VARCHAR(25),
  `alamat` TEXT,
  `email` VARCHAR(100)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 5. Table: barang
CREATE TABLE IF NOT EXISTS `barang` (
  `barang_code` VARCHAR(50) PRIMARY KEY,
  `barcode` VARCHAR(50),
  `barang_name` VARCHAR(150) NOT NULL,
  `tanggal_dibuat` DATE DEFAULT (CURRENT_DATE),
  `harga_beli` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `harga_jual` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `category_id` INT,
  `supplier_id` INT,
  FOREIGN KEY (`category_id`) REFERENCES `barang_category`(`category_id`) ON DELETE SET NULL,
  FOREIGN KEY (`supplier_id`) REFERENCES `supplier`(`supplier_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 6. Table: pembelian
CREATE TABLE IF NOT EXISTS `pembelian` (
  `pembelian_code` VARCHAR(50) PRIMARY KEY,
  `nama_pembelian` VARCHAR(150) NOT NULL,
  `tanggal` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT,
  FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 7. Table: pembelian_has_barang
CREATE TABLE IF NOT EXISTS `pembelian_has_barang` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `pembelian_code` VARCHAR(50) NOT NULL,
  `barang_code` VARCHAR(50) NOT NULL,
  `jumlah` INT NOT NULL DEFAULT 1,
  `harga_satuan` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  `tester_id` INT DEFAULT NULL,
  FOREIGN KEY (`pembelian_code`) REFERENCES `pembelian`(`pembelian_code`) ON DELETE CASCADE,
  FOREIGN KEY (`barang_code`) REFERENCES `barang`(`barang_code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 8. Table: penjualan
CREATE TABLE IF NOT EXISTS `penjualan` (
  `penjualan_code` VARCHAR(50) PRIMARY KEY,
  `nama_penjualan` VARCHAR(150) NOT NULL,
  `tanggal` DATETIME DEFAULT CURRENT_TIMESTAMP,
  `user_id` INT,
  FOREIGN KEY (`user_id`) REFERENCES `user`(`user_id`) ON DELETE SET NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 9. Table: penjualan_has_barang
CREATE TABLE IF NOT EXISTS `penjualan_has_barang` (
  `id` INT AUTO_INCREMENT PRIMARY KEY,
  `penjualan_code` VARCHAR(50) NOT NULL,
  `barang_code` VARCHAR(50) NOT NULL,
  `jumlah` INT NOT NULL DEFAULT 1,
  `harga_satuan` DECIMAL(12, 2) NOT NULL DEFAULT 0.00,
  FOREIGN KEY (`penjualan_code`) REFERENCES `penjualan`(`penjualan_code`) ON DELETE CASCADE,
  FOREIGN KEY (`barang_code`) REFERENCES `barang`(`barang_code`) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;


-- 1. Personal & User
INSERT INTO `personal` (`personal_id`, `nama`, `telepon`, `alamat`) VALUES
(1, 'Alexandria Rivera', '0812-9876-5432', 'Jl. Sudirman No. 45, Jakarta Pusat'),
(2, 'Dimas Pratama', '0857-1122-3344', 'Jl. Gatot Subroto Kav. 12, Jakarta Selatan')
ON DUPLICATE KEY UPDATE `nama` = VALUES(`nama`);

INSERT INTO `user` (`user_id`, `user_name`, `password`, `level`, `personal_id`) VALUES
(1, 'alex_admin', 'admin123', 'Head of Inventory', 1),
(2, 'dimas_staff', 'staff123', 'Warehouse Staff', 2)
ON DUPLICATE KEY UPDATE `user_name` = VALUES(`user_name`);

-- 2. Categories
INSERT INTO `barang_category` (`category_id`, `category_name`) VALUES
(1, 'Computer & Peripherals'),
(2, 'Office Supplies & Stationery'),
(3, 'Networking Hardware'),
(4, 'Audio & Visual Devices')
ON DUPLICATE KEY UPDATE `category_name` = VALUES(`category_name`);

-- 3. Suppliers
INSERT INTO `supplier` (`supplier_id`, `supplier_name`, `telepon`, `alamat`, `email`) VALUES
(1, 'Logitech Global Tech', '021-5551234', 'Kawasan Industri Pulogadung Blok A2', 'sales@logitech-global.id'),
(2, 'PaperOne Paper Mills', '021-5555678', 'Jl. Raya Bekasi KM 28, Bekasi', 'order@paperone.co.id'),
(3, 'Cisco Systems Indonesia', '021-5559012', 'Mega Kuningan Barat Kav. E4, Jakarta', 'partner@cisco-id.com'),
(4, 'Keychron Official Distro', '021-5553456', 'Ruko Sedayu Square Blok C-10, Jakarta Barat', 'distro@keychron.id')
ON DUPLICATE KEY UPDATE `supplier_name` = VALUES(`supplier_name`);

-- 4. Barang
INSERT INTO `barang` (`barang_code`, `barcode`, `barang_name`, `tanggal_dibuat`, `harga_beli`, `harga_jual`, `category_id`, `supplier_id`) VALUES
('BRG-001', '8991001001', 'Logitech MX Master 3S Wireless', '2026-01-10', 1250000, 1550000, 1, 1),
('BRG-002', '8991001002', 'Keychron K2 Pro Mechanical RGB', '2026-01-15', 1400000, 1750000, 1, 4),
('BRG-003', '8992002001', 'Kertas HVS PaperOne A4 80gr 1 Rim', '2026-02-01', 48000, 60000, 2, 2),
('BRG-004', '8993003001', 'Cisco Catalyst Switch 24-Port Gigabit', '2026-02-05', 4500000, 5600000, 3, 3),
('BRG-005', '8991001003', 'USB-C Multiport Adapter 7-in-1', '2026-02-12', 320000, 450000, 1, 1)
ON DUPLICATE KEY UPDATE `barang_name` = VALUES(`barang_name`);

-- 5. Pembelian (Purchase Orders)
INSERT INTO `pembelian` (`pembelian_code`, `nama_pembelian`, `tanggal`, `user_id`) VALUES
('PO-2026-001', 'Restock Mouse & Keyboard Q1', '2026-02-15 09:30:00', 1),
('PO-2026-002', 'Pengadaan Kertas Divisi Administrasi', '2026-02-20 14:15:00', 1),
('PO-2026-003', 'Peralatan Jaringan Ruang Server', '2026-02-25 11:00:00', 2)
ON DUPLICATE KEY UPDATE `nama_pembelian` = VALUES(`nama_pembelian`);

-- 6. Detail Pembelian
INSERT INTO `pembelian_has_barang` (`pembelian_code`, `barang_code`, `jumlah`, `harga_satuan`, `tester_id`) VALUES
('PO-2026-001', 'BRG-001', 30, 1250000, 1),
('PO-2026-001', 'BRG-002', 15, 1400000, 1),
('PO-2026-002', 'BRG-003', 100, 48000, 1),
('PO-2026-003', 'BRG-004', 5, 4500000, 2),
('PO-2026-003', 'BRG-005', 20, 320000, 2);

-- 7. Penjualan (Sales Orders)
INSERT INTO `penjualan` (`penjualan_code`, `nama_penjualan`, `tanggal`, `user_id`) VALUES
('SO-2026-001', 'Penjualan Batch Klien PT Mandiri Tech', '2026-02-22 10:00:00', 1),
('SO-2026-002', 'Permintaan Internal Divisi Marketing', '2026-02-26 15:30:00', 2)
ON DUPLICATE KEY UPDATE `nama_penjualan` = VALUES(`nama_penjualan`);

-- 8. Detail Penjualan
INSERT INTO `penjualan_has_barang` (`penjualan_code`, `barang_code`, `jumlah`, `harga_satuan`) VALUES
('SO-2026-001', 'BRG-001', 5, 1550000),
('SO-2026-001', 'BRG-002', 3, 1750000),
('SO-2026-001', 'BRG-003', 20, 60000),
('SO-2026-002', 'BRG-005', 4, 450000);
