 #创建ATM数据库
 CREATE DATABASE ATM;
 
 #创建用户
CREATE USER `ATMMaster` IDENTIFIED BY '1234';
GRANT ALL ON ATM.* TO 'bankMaster';
CREATE DATABASE `ATM`;
 
 USE  ATM;
 
 ##删除数据库
DROP DATABASE  ATM;
 

#用例3：创建客户信息表添加外键
CREATE TABLE `userInfo`(
  `customerID` INT(4)  NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '客户编号',
  `customerName` CHAR(8) NOT NULL COMMENT '开户名',
  `telephone` CHAR(12) NOT NULL COMMENT '手机号码',
  `address` VARCHAR(50) NOT NULL COMMENT '居住地址',
  `PID` CHAR(18) UNIQUE NOT NULL COMMENT '身份证号'
)ENGINE = INNODB,COMMENT='用户表';

#创建存款类型表
CREATE TABLE `Deposit`(
 `savingID` INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '存款编号',
 `savingName` VARCHAR(20) NOT NULL COMMENT '存款名称',
  `descrip` VARCHAR(50)
)ENGINE = INNODB,COMMENT='存款类型表';

#创建银行卡信息表
CREATE TABLE `cardInfo`(
 `cardID` CHAR(20) NOT NULL PRIMARY KEY  COMMENT '卡号',
 `customerID` INT(4) NOT NULL COMMENT '客户编号',
 `savingID` INT(4) NOT NULL COMMENT '存款类型',
 `curID` VARCHAR(10) NOT NULL DEFAULT "RMB" COMMENT '币种',
 `openDate` TIMESTAMP NOT NULL DEFAULT NOW() COMMENT '开户日期',
 `openMoney` DECIMAL(20,2) NOT NULL COMMENT '开户金额',
 `balance` DECIMAL(20,2) NOT NULL COMMENT '余额',
 `password` CHAR(10) NOT NULL COMMENT '密码',
 `IsReportLoss` INT(2) NOT NULL DEFAULT '0' COMMENT '是否挂失 '
)ENGINE = INNODB,COMMENT='银行卡信息表';

#创建交易信息表
CREATE TABLE `tradeInfo`(
 `tradeNum` INT(4) NOT NULL PRIMARY KEY AUTO_INCREMENT COMMENT '交易流水号',
 `tradeDate` TIMESTAMP NOT NULL DEFAULT NOW() COMMENT '交易日期',
 `tradeType` CHAR(4) NOT NULL COMMENT '交易类型',
 `cardID` CHAR(20) NOT NULL COMMENT '银行卡号',
 `tradeMoney` DECIMAL(20,2) NOT NULL COMMENT '交易金额',
 `remark` VARCHAR(100) NOT NULL COMMENT '备注'
)ENGINE = INNODB,COMMENT='交易信息表';

##创建外键约束
#添加外键约束   主表在后面   从表在前面
#客户信息主表 与 银行卡信息从表 的外键关系
ALTER TABLE  `cardInfo` ADD CONSTRAINT FOREIGN KEY (`customerID`)REFERENCES `userInfo`(`customerID`);
#存款类型主表 与 银行卡信息从表 的外键关系
ALTER TABLE  `cardInfo` ADD CONSTRAINT FOREIGN KEY (`savingID`)REFERENCES `Deposit`(`savingID`);
#银行卡信息主表 与 交易信息表从表 的外键关系
ALTER TABLE  `tradeInfo` ADD CONSTRAINT FOREIGN KEY (`cardID`)REFERENCES `cardInfo`(`cardID`);


#用例4：插入测试数据
#存款类型
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('活期','按存款日结算利息');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('定期一年','存款期是1年');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('定期二年','存款期是2年');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('定期三年','存款期是3年');
INSERT INTO `deposit` (`savingName`) VALUES ('定活两便');
INSERT INTO `deposit` (`savingName`) VALUES ('通知');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('零存整取一年','存款期是1年');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('零存整取二年','存款期是2年');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('零存整取三年','存款期是3年');
INSERT INTO `deposit` (`savingName`,`descrip`) VALUES ('存本取息五年','按月支取利息');
SELECT * FROM `deposit`;
#客户信息
INSERT INTO `userinfo`(`customerName`,`PID`,`telephone`,`address`)VALUES('张三','123456789012345999','010-67898978','北京海淀');
INSERT INTO `userinfo`(`customerName`,`PID`,`telephone`,`address`)VALUES('李四','321245678912345678','765-44443333','云南贵州');
INSERT INTO `userinfo`(`customerName`,`PID`,`telephone`,`address`)VALUES('王五','567891234532124670','010-44443333','湖南长沙');
INSERT INTO `userinfo`(`customerName`,`PID`,`telephone`,`address`)VALUES('丁六','567891321242345618','052-43345543','广东东莞');
SELECT * FROM `userinfo`;
#银行卡信息
INSERT INTO `cardinfo`(`cardID`,`savingID`,`openMoney`,`balance`,`customerID`,`password`)VALUES('1010357612345678',1,1000,1000,1,'123321');
INSERT INTO `cardinfo`(`cardID`,`savingID`,`openMoney`,`balance`,`customerID`,`password`)VALUES('1010357612121134',2,2000,2000,2,'123456');
INSERT INTO `cardinfo`(`cardID`,`savingID`,`openMoney`,`balance`,`customerID`,`password`)VALUES('1010357612121130',2,3000,3000,3,'789789');
INSERT INTO `cardinfo`(`cardID`,`savingID`,`openMoney`,`balance`,`customerID`,`password`)VALUES('1010357612121004',2,4000,4000,4,'456456');
SELECT * FROM cardInfo;
#交易信息表插入交易记录
INSERT INTO `tradeinfo`(`tradeType`,`cardID`,`tradeMoney`) VALUES('支取','1010357612399998',600);
INSERT INTO `tradeinfo`(`tradeType`,`cardID`,`tradeMoney`) VALUES('存入','1010357612121134',4000);  
INSERT INTO `tradeinfo`(`tradeType`,`cardID`,`tradeMoney`) VALUES('支取','1010357612345678',900);
INSERT INTO `tradeinfo`(`tradeType`,`cardID`,`tradeMoney`) VALUES('存入','1010357999911134',5000);    
SELECT * FROM tradeInfo;
#更新银行卡信息表中的现有余额
UPDATE `cardinfo` SET `balance`=`balance`-900 WHERE `cardID`='1010357612345678';
UPDATE `cardinfo` SET `balance`=`balance`+5000 WHERE `cardID`='1010357612121134';
SELECT * FROM cardInfo;



##用例5：模拟常规业务
#1.修改客户密码
#张三（卡号为1010 3576 1234 5678）修改银行卡密码为123321
#李四（卡号为1010 3576 1212 1134）修改银行卡密码为123456
UPDATE `cardinfo` SET `password`='123321' WHERE `cardID`='1010357612345678'; 
UPDATE `cardinfo` SET `password`='123456' WHERE `cardID`='1010357612121134';
SELECT *FROM cardinfo


#2.办理银行卡挂失
#李四（卡号为1010 3576 1212 1134）因银行卡丢失，申请挂失
UPDATE `cardinfo` SET `IsReportLoss`=1 WHERE `cardID`='1010357612121134' ;
SELECT `cardID`AS '卡号',`curID`AS '货币',`savingName`AS '储蓄种类',`openDate`AS '开户日期',`openMoney`AS '开户金额',`balance`AS '余额',`password`AS '密码',
    `IsReportLoss`AS '是否挂失', `customerName`AS '客户姓名'
FROM `cardinfo`, `deposit`, `userinfo`
WHERE `cardinfo`.`savingID`=`deposit`.`savingID` AND `cardinfo`.`customerID` = `userinfo`.`customerID`


#3 统计银行总存入金额和总支取金额
SELECT `tradeType` AS '交易类型',SUM(`tradeMoney`) AS '总金额'
FROM `tradeinfo`
GROUP BY `tradeType`;


#4查询本周开户信息
SELECT C.`cardID`AS '卡号',U.`customerName` AS '姓名',C.`curID`AS '货币',D.`savingName`AS '存款类型',C.`openDate`AS '开户日期',C.`openMoney`AS '开户金额',C.`balance`AS '余额',C.`IsReportLoss`AS '账户状态'
FROM `cardinfo` C 
INNER JOIN `userinfo` U ON (C.`customerID` = U.`customerID`)
INNER JOIN `deposit` D ON (C.`savingID` = D.`savingID` )
WHERE WEEK(NOW()) = WEEK(`openDate`);


#5查询本月交易金额最高的卡号
SELECT DISTINCT `cardID`
FROM `tradeinfo`
WHERE `tradeMoney`=(
  SELECT MAX(`tradeMoney`) 
  FROM `tradeinfo`
  WHERE MONTH(`tradeDate`)=MONTH(NOW())AND YEAR(`tradeDate`)=YEAR(NOW())
  );
  
  
  
#6查询挂失客户信息
SELECT `customerName` AS '客户姓名',`telephone` AS '联系电话'
FROM `userinfo`
WHERE `customerID` IN(SELECT `customerID` FROM `cardinfo` WHERE `IsReportLoss`=1)


#7催款提醒业务
SELECT `customerName` AS '客户姓名',`telephone` AS '联系电话',`balance` AS '存款金额'
FROM  `userinfo`
INNER JOIN `cardinfo` ON `cardinfo`.`customerID`=`userinfo`.`customerID`
WHERE `balance`<200;




##用例6：创建、使用客户有好信息视图
#view_userInfo：输出银行客户记录
DROP VIEW IF EXISTS view_userInfo;
#输出银行客户记录
CREATE VIEW view_userInfo 
AS 
SELECT `customerID` AS 客户编号,`customerName` AS 开户名, `PID` AS 身份证号,`telephone` AS 电话号码,`address` AS 居住地址  
FROM userInfo;
#查看
SELECT * FROM view_userInfo;
 

#view_cardInfo：输出银行卡记录
DROP VIEW IF EXISTS view_cardInfo;
#银行卡信息表视图
CREATE VIEW view_cardInfo  
AS 
SELECT c.cardID AS '卡号',u.customerName AS '客户',c.curID AS '货币种类', d.savingName AS '存款类型',c.openDate AS '开户日期',c.balance AS '余额',c.password AS '密码',IsReportLoss AS '是否挂失'
FROM `cardinfo` c, `deposit` d,`userinfo` u
WHERE c.`savingID`=d.`savingID` AND c.`customerID`=u.`customerID`;
#查看
SELECT * FROM view_cardInfo;
 
#view_transInfo：输出银行卡的交易记录
DROP VIEW IF EXISTS view_transInfo;

CREATE VIEW view_transInfo 
AS 
SELECT `tradeDate` AS '交易日期',`tradeType` AS '交易类型', `cardID` AS '卡号',`tradeMoney` AS '交易金额',`remark` AS '备注'  
FROM `tradeinfo`;
#查看
SELECT * FROM view_transInfo;




#用例7：使用事务完成转账
#从卡号为“1010357612121134”的账户中转出300元给卡号为“1010357612345678”的账户-
BEGIN;
INSERT INTO tradeInfo(tradeType,cardID,tradeMoney) 
      VALUES('支取','1010357612121134',300);   
UPDATE cardInfo SET balance=balance-300 WHERE cardID='1010357612121134';
INSERT INTO tradeInfo(tradeType,cardID,tradeMoney) 
      VALUES('存入','1010357612345678',300);  
UPDATE cardInfo SET balance=balance+300 WHERE cardID='1010357612345678';
COMMIT;   #提交事务
ROLLBACK; #回滚事务

SELECT * FROM cardInfo;
SELECT * FROM tradeInfo;