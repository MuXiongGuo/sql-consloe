create table emp (
    id int comment '编号',
    workNo varchar(10) comment '工号',
    name varchar(10) comment '姓名',
    gender char(1) comment '性别',
    age tinyint unsigned comment '年龄',
    idCard char(18) comment '身份证',
    entryDate date comment '入职时间'
) comment '员工表';