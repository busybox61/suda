# Table::delete
根据条件删除列
> *文件信息* suda\archive\Table.php: 31~944
## 所属类 

[Table](../Table.md)

## 可见性

  public  
## 说明


用于提供对数据表的操作


## 参数

| 参数名 | 类型 | 默认值 | 说明 |
|--------|-----|-------|-------|
| where |  [type] | 无 |  删除条件 |
| binds |  array | Array |  条件值绑定 |

## 返回值
类型：integer
无

## 例子


**键值对**

删除 ID 为3的记录

```php
$table->update(['id'=>3]);
```

**条件**

删除 ID>3  的记录

```php
$table->delete('id > :id ',['id'=>3]);
```