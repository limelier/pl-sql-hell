select
    s1.an,
    s1.grupa,
    count(distinct s1.id) as nr_std,
    count(p.id_student1) as nr_prieteni,
    trunc(count(p.id_student1) / count(distinct s1.id), 2) as coeziune
from 
    studenti s1 join
    prieteni p on s1.id = p.id_student1 join
    studenti s2 on s2.id = p.id_student2
group by s1.an, s1.grupa
order by trunc(count(p.id_student1) / count(distinct s1.id), 2);