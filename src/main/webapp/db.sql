CREATE DATABASE pharmacy;
USE pharmacy;
SHOW DATABASES;
CREATE TABLE medicine (
  id INT AUTO_INCREMENT PRIMARY KEY,
  name VARCHAR(100) NOT NULL,
  manufacturer VARCHAR(100),
  price DECIMAL(8,2)
);

USE pharmacy;

ALTER TABLE medicine
  ADD COLUMN sku   VARCHAR(50) NOT NULL AFTER manufacturer,
  ADD COLUMN stock INT           NOT NULL DEFAULT 0          AFTER price;



/* sample data */
-- -------------------------------------------------------------------
--  Seed data for `medicine` (100 rows) – 5-column version
-- -------------------------------------------------------------------
INSERT INTO medicine (name, manufacturer, sku, price, stock) VALUES
  ('Paracetamol 500 mg',            'GSK Consumer Healthcare', 'MED-0001',  3.2, 500),
  ('Ibuprofen 400 mg',              'Abbott Pakistan',         'MED-0002',  3.0, 450),
  ('Amoxicillin 500 mg',            'Sami Pharma',             'MED-0003', 20.0, 120),
  ('Diclofenac Sodium 50 mg',       'Novartis Pakistan',       'MED-0004',  4.5, 300),
  ('Aspirin 75 mg',                 'Atco Pharma',             'MED-0005',  2.5, 400),
  ('Naproxen 500 mg',               'Hilton Pharma',           'MED-0006', 10.0, 180),
  ('Ketoprofen 100 mg',             'Bosch Pharma',            'MED-0007', 12.0, 150),
  ('Tramadol 50 mg',                'Searle Pakistan',         'MED-0008', 25.0,  90),
  ('Celecoxib 200 mg',              'Pfizer Pakistan',         'MED-0009', 30.0,  80),
  ('Indomethacin 25 mg',            'Highnoon Labs',           'MED-0010',  8.0, 140),
  ('Meloxicam 15 mg',               'Getz Pharma',             'MED-0011', 15.0, 160),
  ('Ciprofloxacin 500 mg',          'Bayer Pakistan',          'MED-0012', 65.0, 100),
  ('Azithromycin 250 mg',           'Acme Labs',               'MED-0013', 60.0, 110),
  ('Cefixime 400 mg',               'AGP Ltd.',                'MED-0014',100.0,  90),
  ('Ceftriaxone 1 g inj.',          'Ferozsons Labs',          'MED-0015',200.0,  60),
  ('Doxycycline 100 mg',            'Brookes Pharma',          'MED-0016', 15.0, 130),
  ('Metronidazole 400 mg',          'PharmEvo',                'MED-0017',  4.0, 250),
  ('Levofloxacin 500 mg',           'Saffron Pharma',          'MED-0018', 45.0,  90),
  ('Clarithromycin 500 mg',         'Getz Pharma',             'MED-0019', 90.0,  80),
  ('Clindamycin 300 mg',            'Searle Pakistan',         'MED-0020', 40.0,  85),
  ('Piperacillin/Tazobactam 4.5 g', 'Sami Pharma',             'MED-0021',600.0,  40),
  ('Cefuroxime 500 mg',             'Zafa Pharma',             'MED-0022', 70.0,  95),
  ('Amikacin 500 mg inj.',          'Bosch Pharma',            'MED-0023',110.0,  55),
  ('Losartan 50 mg',                'Don Valley Pharma',       'MED-0024', 22.0, 210),
  ('Amlodipine 5 mg',               'Pfizer Pakistan',         'MED-0025', 15.0, 230),
  ('Atenolol 50 mg',                'GSK Pakistan',            'MED-0026',  8.0, 240),
  ('Bisoprolol 5 mg',               'Getz Pharma',             'MED-0027', 12.0, 180),
  ('Enalapril 10 mg',               'Highnoon Labs',           'MED-0028', 10.0, 190),
  ('Lisinopril 10 mg',              'Searle Pakistan',         'MED-0029', 11.0, 190),
  ('Metoprolol 50 mg',              'Novartis Pakistan',       'MED-0030',  9.0, 200),
  ('Valsartan 80 mg',               'Getz Pharma',             'MED-0031', 30.0, 160),
  ('Diltiazem 60 mg',               'Martin Dow',              'MED-0032', 18.0, 170),
  ('Olmesartan 20 mg',              'AGP Ltd.',                'MED-0033', 45.0, 140),
  ('Hydrochlorothiazide 25 mg',     'PharmEvo',                'MED-0034',  3.0, 260),
  ('Carvedilol 12.5 mg',            'Brookes Pharma',          'MED-0035', 14.0, 150),
  ('Metformin 500 mg',              'Don Valley Pharma',       'MED-0036',  6.0, 500),
  ('Glimepiride 2 mg',              'Sanofi Aventis PK',       'MED-0037',  9.0, 220),
  ('Gliclazide 60 mg MR',           'Searle Pakistan',         'MED-0038',  8.0, 210),
  ('Sitagliptin 100 mg',            'Merck PK',                'MED-0039', 65.0, 100),
  ('Empagliflozin 25 mg',           'Boehringer Ingelheim PK', 'MED-0040',120.0,  90),
  ('Insulin Glargine 100 IU',       'Sanofi Aventis PK',       'MED-0041',1500.0, 30),
  ('Insulin Regular R 100 IU',      'Novo Nordisk PK',         'MED-0042', 350.0, 50),
  ('Pioglitazone 30 mg',            'Martin Dow',              'MED-0043', 22.0, 140),
  ('Dulaglutide 0.75 mg pen',       'Lilly PK',                'MED-0044',4500.0, 25),
  ('Glibenclamide 5 mg',            'AGP Ltd.',                'MED-0045',  5.0, 240),
  ('Atorvastatin 20 mg',            'Pharmatec PK',            'MED-0046', 25.0, 200),
  ('Rosuvastatin 20 mg',            'Getz Pharma',             'MED-0047', 35.0, 180),
  ('Simvastatin 20 mg',             'Bosch Pharma',            'MED-0048', 18.0, 190),
  ('Fenofibrate 200 mg',            'Hilton Pharma',           'MED-0049', 28.0, 160),
  ('Ezetimibe 10 mg',               'Searle Pakistan',         'MED-0050', 30.0, 140),
  ('Omeprazole 20 mg',              'Getz Pharma',             'MED-0051', 12.0, 260),
  ('Pantoprazole 40 mg',            'Highnoon Labs',           'MED-0052', 18.0, 240),
  ('Esomeprazole 40 mg',            'AstraZeneca PK',          'MED-0053', 22.0, 200),
  ('Ranitidine 150 mg',             'Novartis Pakistan',       'MED-0054',  4.0, 280),
  ('Famotidine 40 mg',              'AGP Ltd.',                'MED-0055',  5.0, 260),
  ('Domperidone 10 mg',             'Sami Pharma',             'MED-0056',  6.0, 240),
  ('Loperamide 2 mg',               'Johnson & Johnson PK',    'MED-0057',  3.0, 260),
  ('Ondansetron 8 mg',              'Getz Pharma',             'MED-0058', 15.0, 160),
  ('Salbutamol 100 µg inhaler',     'GSK Pakistan',            'MED-0059',140.0, 90),
  ('Budesonide 200 µg inhaler',     'AstraZeneca PK',          'MED-0060',350.0, 80),
  ('Montelukast 10 mg',             'Hilton Pharma',           'MED-0061', 20.0, 180),
  ('Cetirizine 10 mg',              'Bosch Pharma',            'MED-0062',  5.0, 300),
  ('Loratadine 10 mg',              'Schazoo Zaka PK',         'MED-0063', 10.0, 280),
  ('Fexofenadine 120 mg',           'Getz Pharma',             'MED-0064', 25.0, 200),
  ('Fluticasone nasal spray 50 µg', 'GSK Pakistan',            'MED-0065',450.0, 60),
  ('Diazepam 5 mg',                 'Martin Dow',              'MED-0066',  3.0, 220),
  ('Alprazolam 0.5 mg',             'Searle Pakistan',         'MED-0067',  5.0, 200),
  ('Sertraline 50 mg',              'AGP Ltd.',                'MED-0068', 14.0, 140),
  ('Fluoxetine 20 mg',              'Hilton Pharma',           'MED-0069',  9.0, 150),
  ('Amitriptyline 25 mg',           'Bosch Pharma',            'MED-0070',  4.0, 200),
  ('Olanzapine 10 mg',              'Sami Pharma',             'MED-0071', 30.0, 120),
  ('Risperidone 2 mg',              'Johnson & Johnson PK',    'MED-0072', 20.0, 130),
  ('Levothyroxine 50 µg',           'Getz Pharma',             'MED-0073',  2.0, 400),
  ('Prednisolone 5 mg',             'Pfizer Pakistan',         'MED-0074',  7.0, 250),
  ('Hydrocortisone cream 1%',       'GSK Pakistan',            'MED-0075', 90.0, 100),
  ('Progesterone 200 mg',           'Martin Dow',              'MED-0076', 80.0,  70),
  ('COCP (EE/LNG)',                 'Wyeth PK',                'MED-0077', 15.0, 180),
  ('Diclofenac 75 mg inj.',         'Novartis Pakistan',       'MED-0078', 25.0,  90),
  ('Ketorolac 30 mg inj.',          'Searle Pakistan',         'MED-0079', 35.0,  80),
  ('Morphine 10 mg inj.',           'Hamaz Pharma',            'MED-0080',100.0,  40),
  ('Vitamin C 500 mg',              'Highnoon Labs',           'MED-0081',  4.0, 500),
  ('Vitamin D3 2000 IU',            'AGP Ltd.',                'MED-0082', 10.0, 350),
  ('Calcium + Vit D tab',           'Getz Pharma',             'MED-0083', 12.0, 300),
  ('Ferrous Sulfate 200 mg',        'PharmEvo',                'MED-0084',  3.0, 400),
  ('ORS sachet',                    'Ferozsons Labs',          'MED-0085', 12.0, 320),
  ('Zinc sulfate 20 mg',            'Brookes Pharma',          'MED-0086',  4.0, 350),
  ('Clopidogrel 75 mg',             'Searle Pakistan',         'MED-0087', 18.0, 140),
  ('Warfarin 5 mg',                 'Zafa Pharma',             'MED-0088',  7.0, 180),
  ('Heparin 5000 IU inj.',          'Pfizer Pakistan',         'MED-0089',120.0,  40),
  ('Aspirin 300 mg',                'Atco Pharma',             'MED-0090',  3.0, 300),
  ('Ginkgo Biloba 120 mg',          'Herbion PK',              'MED-0091', 25.0, 160),
  ('Probiotic capsule',             'Nutrifactor PK',          'MED-0092', 30.0, 180),
  ('Rabeprazole 20 mg',             'Sami Pharma',             'MED-0093', 20.0, 190),
  ('Tamsulosin 0.4 mg',             'Getz Pharma',             'MED-0094', 18.0, 150),
  ('Sildenafil 100 mg',             'Pfizer Pakistan',         'MED-0095', 90.0,  70),
  ('Misoprostol 200 µg',            'Highnoon Labs',           'MED-0096', 20.0,  60),
  ('Mebeverine 135 mg',             'Hilton Pharma',           'MED-0097', 10.0, 170),
  ('Allopurinol 300 mg',            'AGP Ltd.',                'MED-0098',  8.0, 190),
  ('Colchicine 0.5 mg',             'Ferozsons Labs',          'MED-0099',  5.0, 200),
  ('Insulin Aspart 100 IU',         'Novo Nordisk PK',         'MED-0100',1600.0, 35);



select * from medicine;
DELETE FROM medicine;
TRUNCATE TABLE medicine;







INSERT INTO customers (first_name, last_name, primary_contact, address, is_admin, total_purchase_worth)
VALUES ('Walk-in', ' Customer', '923000000000', "@ Physical Shop", false, 0.0);

CREATE TABLE customers (
  customer_id           INT             AUTO_INCREMENT PRIMARY KEY,
  first_name            VARCHAR(50)    NOT NULL,
  last_name             VARCHAR(50)   NOT NULL,
  primary_contact       VARCHAR(20)     NOT NULL,
  secondary_contact     VARCHAR(20)     DEFAULT NULL,
  address               VARCHAR(255)    DEFAULT NULL,
  is_admin              BOOLEAN         NOT NULL DEFAULT FALSE,
  total_purchase_worth  DECIMAL(10,2)   NOT NULL DEFAULT 0.00
) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;

CREATE TABLE orders (
  order_id        INT             AUTO_INCREMENT PRIMARY KEY,
  customer_id     INT             NOT NULL,
  total_items     INT             NOT NULL DEFAULT 0,
  total_price     DECIMAL(10,2)   NOT NULL DEFAULT 0.00,
  order_timestamp DATETIME        NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT fk_orders_customer
    FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_timestamp (order_timestamp)
) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;
CREATE TABLE order_line_items (
  order_item_id   INT             AUTO_INCREMENT PRIMARY KEY,
  order_id        INT             NOT NULL,
  medicine_id     INT             NOT NULL,
  quantity        INT             NOT NULL DEFAULT 1,
  unit_price      DECIMAL(10,2)   NOT NULL,
  total_price     DECIMAL(10,2)   GENERATED ALWAYS AS (quantity * unit_price) STORED,
  
  CONSTRAINT fk_oli_order
    FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
    
  CONSTRAINT fk_oli_medicine
    FOREIGN KEY (medicine_id)
    REFERENCES medicine(id)
    ON DELETE RESTRICT
    ON UPDATE CASCADE,
    
  INDEX idx_oli_order       (order_id),
  INDEX idx_oli_medicine    (medicine_id)
) ENGINE=InnoDB
  DEFAULT CHARSET = utf8mb4
  COLLATE = utf8mb4_unicode_ci;



show tables;
select * from customers;
select * from order_line_items;
select * from orders;
SHOW ENGINE INNODB STATUS;


UPDATE customers
SET
  
  first_name           = 'John',
  last_name            = 'Doe',
  primary_contact      = '+1234567890',
  secondary_contact    = '+0987654321',
  address              = '123 Main St, Anytown, Country',
  is_admin             = FALSE,
  total_purchase_worth = 249.99
WHERE customer_id = 2;

UPDATE customers
SET
  username = "test",
  password_hash = "96cae35ce8a9b0244178bf28e4966c2ce1b8385723a96a6b838858cdd6ca0a1e"
  
WHERE customer_id = 1;

