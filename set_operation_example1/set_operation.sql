/* 和 */
select * 
from companyA
union 
select * 
from companyB;

/* 直積 */
select companyA.* , department.* 
from companyA 
cross join department;