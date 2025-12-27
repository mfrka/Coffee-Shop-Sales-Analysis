-- Membangun Database
select database();
use Coffee_shop;
select * from Coffee_shop.Penjualan;
describe penjualan;


-- Perubahan nama tabel, kolom dan lain sebagainya
alter table coffee_shop_sales_revenue rename to Penjualan;
alter table Penjualan 
change transaction_id id_transaksi int,
change transaction_date tanggal_transaksi DATE, 
change transaction_time waktu_transaksi time, 
change transaction_qty jumlah_transaksi int, 
change store_id id_toko int, 
change store_location lokasi_toko varchar (100),
change product_id id_produk int,
change unit_price harga_satuan decimal (12,2),
change product_category kategori_produk varchar (100),
change product_type tipe_produk varchar (100),
change product_detail detail_produk varchar (100);

-- 1. Data Understanding
# Menghitung jumlah total baris data
select count(*) from Coffee_shop.Penjualan; 

# Memeriksa apakah terdapat nilai kosong atau nilai tidak valid
select * from penjualan where 
id_transaksi is null or
tanggal_transaksi is null or 
waktu_transaksi is null or 
jumlah_transaksi is null or
id_toko is null or
lokasi_toko is null or 
id_produk is null or 
harga_satuan is null or 
kategori_produk is null or
tipe_produk is null or 
detail_produk is null; 

# Memeriksa rentang nilai seperti harga atau quantity
select 
min(harga_satuan) as harga_terkecil, 
max(harga_satuan) as harga_terbesar, 
min(jumlah_transaksi) as qty_terkecil, 
max(jumlah_transaksi) as qty_terbesar, 
max(harga_satuan)-min(harga_satuan) as rentang_harga, 
max(jumlah_transaksi)-min(jumlah_transaksi) as rentang_qty
from penjualan;

-- 2. Analisis Dasar Menggunakan SQL
# Produk apa yang memiliki jumlah penjualan terbanyak
select kategori_produk, sum(jumlah_transaksi) as total_terjual
from penjualan group by kategori_produk order by total_terjual desc;

# Total pendapatan harian pada periode data
select tanggal_transaksi, sum(harga_satuan * jumlah_transaksi) as Total_pendapatan_harian
from penjualan group by tanggal_transaksi order by total_pendapatan_harian desc;

# Kategori produk mana yang menghasilkan pendapatan tertinggi
select kategori_produk, sum(harga_satuan * jumlah_transaksi) as pendapatan_tertinggi
from penjualan group by kategori_produk order by pendapatan_tertinggi desc;

# Rata-rata transaksi per hari
select avg(total_pendapatan_harian) as rata_rata_transaksi_per_hari
from ( select tanggal_transaksi, sum(harga_satuan * jumlah_transaksi) 
as total_pendapatan_harian from penjualan group by tanggal_transaksi) 
as pendapatan_harian;

# Pola jam penjualan (jam berapa penjualan paling tinggi)
select hour(waktu_transaksi) as jam, sum(harga_satuan * jumlah_transaksi) as total_pendapatan
from penjualan group by jam order by total_pendapatan desc;

# Tren penjualan berdasarkan hari dalam seminggu
select tanggal_transaksi, case dayofweek(tanggal_transaksi) 
when 1 then 'Minggu' when 2 then 'Senin' when 3 then 'Selasa'
when 4 then 'Rabu' when 5 then 'Kamis' when 6 then 'Jumat'
when 7 then 'Sabtu' end as hari, sum(harga_satuan * jumlah_transaksi) 
as total_pendapatan from Penjualan group by tanggal_transaksi, hari
order by tanggal_transaksi; -- Tren per hari dalam satu minggu setiap bulan

select case dayofweek(tanggal_transaksi) when 1 then 'Minggu' when 2 then 'Senin'
when 3 then 'Selasa' when 4 then 'Rabu' when 5 then 'Kamis' when 6 then 'Jumat'
when 7 then 'Sabtu' end as hari, SUM(harga_satuan * jumlah_transaksi) 
as total_pendapatan from Penjualan group by hari order by 
total_pendapatan desc; -- Tren per hari dalam satu minggu secara keseluruhan

-- 3. Analisis Pengelompokan Data
# Menampilkan hari dengan jumlah transaksi lebih dari nilai tertentu
select dayname(tanggal_transaksi) as hari, count(*) as jumlah_transaksi
from penjualan group by hari having count(*) > 1000 
order by jumlah_transaksi desc;

# Menampilkan produk yang total penjualannya melewati jumlah tertentu
select kategori_produk, sum(jumlah_transaksi) as jumlah_produk_terjual from penjualan
group by kategori_produk having sum(jumlah_transaksi) > 1000 order by jumlah_produk_terjual desc;
