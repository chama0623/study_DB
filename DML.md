# データベース言語SQLとは
SQL(Structured Query Language)は関係データベースにおける標準的な操作言語である. 
SQL文はDMLとDDLの2つに分けられる. DML(Data Manipulate Language);データ操作言語はselectやinsertを代表とするデータを操作するための命令である.
DDL(Data Definition Language);データ操作言語はcreateやdropを代表とする概念スキーマに関する命令である. ここではDMLの代表的な命令について説明する.  
文法構造について, []は省略可能なもの, |はORを表す.

# DML命令
ここではDML命令としてselect, insert, update, deleteの4つの文について説明する.

## select
select文の基本構文を次に示す. select文で列名を指定することで射影演算を行うことができる. さらに列名のリストに' * 'を指定することで全ての列を取り出すことができる.

```
select [all|distinct] 列名のリスト
from 表名のリスト
[where 選択条件や結合条件]
[group by 列名のリスト]
[having グループ選択条件]
[order by 列名のリスト]
```
### where
where句は選択条件を指定して, 特定の行を取り出すことで選択演算を行うことができる. 
選択条件は比較演算子を用いて指定する. where句の例を次に示す．
大小比較に関しては一般的な不等号記号で指定を行うが, '等しい'判定には' = ', '等しくない'判定には' <> 'を用いる. ただしNULLを指定する場合は「where 列 is NULL」というふうにする. 
```sql
where student.age = 21 /* 年齢が21歳の人のみ */
where student.age <> /* 年齢が21歳でないの人のみ */
```

複数の条件を指定して行を特定する場合は論理演算子(and, or, not)を用いる. 論理演算子を用いたwhere句の例を次に示す.
```sql
where student.age > 21 and student.age < 24
where student.age > 21 or student.year == 2
```

where句においてある値が値1～値2に入っているか判定を行うときに, between述語を用いることがある. 例えばの21歳以上, 24歳以下の判定をbetween述語を用いると次のようになる.

```sql
where student.age between 21 and 24
```

リストで指定した値のうちどれかに該当するか判定したいときはin述語を用いることがある. 21歳, 22歳, 23歳のどれかに該当するかの判定をin述語を用いると次のようになる. リストに含まれないか判定したいときはnot inを用いる.

```sql
where student.age in (21, 22, 23)
```

### distinct
重複行を削除するときはselect文の列名指定にdistinct述語を用いる. 

### like
列の値があるパターンに合致するか判定を行うときはlike述語を用いる. like述語ではパターン文字を用いてパターンの合致を行うことができる. 例えば「中川」で始まるを判定したいときは「中川%」のようにする. このほかの例を次に示す. ' % 'は0文字以上の任意の文字列, ' _ 'は任意の1文字を意味する. 
```sql
where student.name like '中川%' /* 中川 で始まる */
where student.name like '%夏紀' /* 夏紀 で終わる */
where student.name like 'a__b' /* aで始まってbで終わる4文字 */
```

### group by
group by句は取り出した行を指定した列の値でグループ化し, グループごとの統計量を求めることに用いる. さらにhaving句を用いるとグループのうち条件にあったグループのみを取り出すことができる. 例えば次のような表に対して次のようなクエリを実行すると実行結果は次のようになる. このクエリではgroup_codeごとにグループにして, 要素の数をカウントしている. 行の総数を求めるときはcount(*), 列を指定して総数や統計量を求めるときは関数(列名)で指定を行う.

```
+-------+-----------------+------------+
| code  | name            | group_code |
+-------+-----------------+------------+
| 11001 | 中川夏紀        | E01        |
| 11002 | 吉川優子        | E02        |
| 11003 | 傘木希美        | E02        |
| 11004 | 鎧塚みぞれ      | J01        |
+-------+-----------------+------------+
```

```sql
select group_code, count(*)
from companyA
group by group_code;
```

```
+------------+----------+
| group_code | count(*) |
+------------+----------+
| E01        |        1 |
| E02        |        2 |
| J01        |        1 |
+------------+----------+
```

### having 
order by句を用いた後で条件判定を行う場合はhaving句を用いる. having句を用いた例を次に示す.

```sql
select group_code, count(*)
from companyA
group by group_code
having count(*) >=2;
```

```
+------------+----------+
| group_code | count(*) |
+------------+----------+
| E02        |        2 |
+------------+----------+
```

### order by
特定の列の値でソートを行って表示を行う場合にorder by句を用いる. order by句の例を次に示す.
```sql
order by student.age asc /* 年齢昇順 */
order by student.age desc /* 年齢降順 */
order by student.age desc, student.length asc /* 年齢降順, 身長昇順 */
```

### as
asを用いて表に別名をつけることができる. 別名とつけるときは「表名 as 別名」のように指定する.

### 副問合せ
from句やwhere句, having句に入れ子になったselect文を副問合せという. 副問合せにはinを用いたものとexistsを用いたものがある.  
inを用いた副問合せについて説明する. 例を次に示す. このクエリでは調査対象表の指定年齢を満たす年齢の社員の社員コードと社員名を社員表から取り出している.
```sql
select 社員コード, 社員名
from 社員表
where 年齢 in (select 指定年齢 from 調査対象表);
```

existsを用いた副問合せの例を次に示す.
```sql
select 社員コード, 社員名
from 社員表
where exists (select * from 調査対象表 where 社員表.年齢 = 調査対象表.指定年齢)
```

## insert
insert文は表に行を挿入するときに用いる. insert文の使い方としては, values句で値を指定して挿入する方法と, select文の問い合わせ結果を挿入方法の2つがある. valuse句で値を指定するときの構文とその例を次に示す.
```sql
insert into 表名 [列名のリスト] values(値リスト)
```

```
insert into companyA values(11001, '中川夏紀', 'E01');
```

select文の問い合わせ結果を挿入する場合の文法を次に示す.
```sql
insert into 表名 [列名のリスト] select文
```

## update
update文は表中のデータを変更する場合に用いる. update文の使い方としては列の変更値を直接指定する方法と, 変更値をcase式によって決める方法, 副問合せの結果を変更値とする方法の3つがある. それぞれの文法を次に示す.

```sql
update 表名 set 列名=変更値 [where 条件] /* 直接指定 */
update 表名 set 列名=case式 [where 条件] /* case式で指定 */
update 表名 set 列名=(select文) [where 条件] /* 副問合せで指定 */
```

## delete
delete文は表中の行を削除するために用いる. select文の構文を次に示す.
```
delete from 表名 [where 条件]
```

# 参照関係を持つ表の更新
関連する2つの表間に参照制約が設定されている場合, 被参照表の主キーにない値を参照表の外部キーに追加することはできない. また被参照表の更新や削除は制約を受ける. 被参照表の行を更新・変更するときの制約・動作は参照動作指定によって明示的に指定できる. これはcreate table文において, references句で指定する. 