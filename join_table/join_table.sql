/* natural join */
select code, name, companyA.group_code, group_name
from companyA, department
where companyA.group_code = department.group_code;



/* inner join */
select code, name, companyA.group_code, group_name
from companyA
inner join department
on companyA.group_code = department.group_code;



/* left outer join */
select code, name, companyA.group_code, group_name
from companyA
left join department
on companyA.group_code = department.group_code;



/* right outer join */
select code, name, companyA.group_code, group_name
from companyA
right join department
on companyA.group_code = department.group_code;