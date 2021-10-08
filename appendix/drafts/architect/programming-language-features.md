

### Scala
#### Access Modifier

| 访问修饰符                | 最高可见范围                           |
| ----------------------- | :------------------------------------- |
| public                  | 全体可见                               |
| private                 | 本类及伴生对象内可见                   |
| private[package.name]   | 本类及伴生对象及`package.name`包内可见 |
| private[this]           | `this`对象可见                         |
| protected               | 子类可见                               |
| protected[package.name] | 子类及`package.name`包内可见           |
| protected[this]         | 同`private[this]`                     |



