create table if not exists tb_user
(
    id     int         null comment '编号',
    name   varchar(50) null comment '姓名',
    age    int         null comment '年龄',
    gender varchar(1)  null comment '性别'
)
    comment '用户表';

