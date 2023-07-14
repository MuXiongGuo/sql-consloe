# leetcode 176
select ifnull((select salary from emp where salary < 0), null);
select max(age)
from emp;

# leetcode 183
# 没必要联合查询, 只要not in 即可, 而id可直接得到
select Name 'Customers'
from Customers
where id not in (select c.Id
                 from Customers c
                          cross join
                      Orders o
                 where c.id = o.CustomerId);
# 官方
select Customers.Name 'Customers'
from Customers
where Customers.id not in (select Orders.CustomerId
                           from Orders);


# 184
# 速度有些慢了 不该用 cross join
select d.name 'Department',
        e.name 'Employee',
        e.salary 'Salary'
from Employee e
        cross join
     Department d
where salary = (
    select max(salary) from Employee where Employee.departmentId = e.departmentId
) and d.id = e.departmentId ;

# 官方 用到了 group by 速度比我们每次都要查 快很多, 而且用到了两个字段的in
SELECT
    Department.name AS 'Department',
    Employee.name AS 'Employee',
    Salary
FROM
    Employee
        JOIN
    Department ON Employee.DepartmentId = Department.Id
WHERE
    (Employee.DepartmentId , Salary) IN
    (   SELECT
            DepartmentId, MAX(Salary)
        FROM
            Employee
        GROUP BY DepartmentId
	)
;



# 185
# 前三高 不太好弄, 老方法干掉, 利用in即可, as ttt 以及 套双select都是语法问题 值得以后深度研究
select d.name 'Department',
        e.name 'Employee',
        e.salary 'Salary'
from Employee e
        inner join
     Department d
on e.departmentId = d.id
where e.salary in (
    select es from (
    select distinct e2.salary es
    from Employee e2
    where e2.departmentId = e.departmentId
    order by e2.salary desc
    limit 3) as ttt
);

# 官方一如既往的优雅!!!
SELECT
    d.Name AS 'Department', e1.Name AS 'Employee', e1.Salary
FROM
    Employee e1
        JOIN
    Department d ON e1.DepartmentId = d.Id
WHERE
    3 > (SELECT
            COUNT(DISTINCT e2.Salary)
        FROM
            Employee e2
        WHERE
            e2.Salary > e1.Salary
                AND e1.DepartmentId = e2.DepartmentId
        )
;


# web book use
use itheima;
CREATE TABLE `userinfo` (
 `uid` INT(10) NOT NULL AUTO_INCREMENT,
 `username` VARCHAR(64) NULL DEFAULT NULL,
 `departname` VARCHAR(64) NULL DEFAULT NULL,
 `created` DATE NULL DEFAULT NULL,
 PRIMARY KEY (`uid`)
);

CREATE TABLE `userdetail` (
 `uid` INT(10) NOT NULL DEFAULT '0',
 `intro` TEXT NULL,
 `profile` TEXT NULL,
 PRIMARY KEY (`uid`)
);

create table user_info(id int(11), username varchar(20), departname varchar(20), create_time timestamp, primary key(id));
use itheima;
desc user_info;

use itcast;
CREATE TABLE `userinfo` (
 `uid` INTEGER PRIMARY KEY auto_increment,
 `username` VARCHAR(64) NULL,
 `departname` VARCHAR(64) NULL,
 `created` DATE NULL
);
CREATE TABLE `userdeatail` (
 `uid` INT(10) NOT NULL,
 `intro` TEXT NULL,
 `profile` TEXT NULL,
 PRIMARY KEY (`uid`)
);


use mysql;
GRANT ALL ON *.* TO 'kalacloud-remote'@'%' WITH GRANT OPTION;

FLUSH PRIVILEGES;

use blog;

# 为表添加字段
ALTER TABLE blog_article ADD cover_image_url varchar(255) DEFAULT '' COMMENT '封面图片地址';

ALTER TABLE blog_article DROP nickname;