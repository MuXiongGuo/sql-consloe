alter table emp add nickName varchar(20) comment '昵称';  # 添加字段

alter table emp change nickName userName varchar(30) comment '用户名';  # 修改字段

alter table emp drop userName;  # 删除字段

alter table emp rename to employee;



