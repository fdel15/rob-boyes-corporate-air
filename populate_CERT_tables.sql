if 0 = (select count(*) from Res)
insert Res
select * from Sabre_PROD.dbo.Res

if 0 = (select count(*) from ResPassenger)
insert ResPassenger
select * from Sabre_PROD.dbo.ResPassenger

if 0 = (select count(*) from ResRemark)
insert ResRemark
select * from Sabre_PROD.dbo.ResRemark

if 0 = (select count(*) from TktCoupon)
insert TktCoupon
select * from Sabre_PROD.dbo.TktCoupon

if 0 = (select count(*) from TktCouponHistory)
insert TktCouponHistory
select * from Sabre_PROD.dbo.TktCouponHistory

if 0 = (select count(*) from TktDocument)
insert TktDocument
select * from Sabre_PROD.dbo.TktDocument

if 0 = (select count(*) from TktFees)
insert TktFees
select * from Sabre_PROD.dbo.TktFees

if 0 = (select count(*) from TktTax)
insert TktTax
select * from Sabre_PROD.dbo.TktTax