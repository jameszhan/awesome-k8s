| 访问修饰符              | 最高可见范围                           |
| ----------------------- | :------------------------------------- |
| public                  | 全体可见                               |
| private                 | 本类及伴生对象内可见                   |
| private[package.name]   | 本类及伴生对象及`package.name`包内可见 |
| private[this]           | `this`对象可见                         |
| protected               | 子类可见                               |
| protected[package.name] | 子类及`package.name`包内可见           |
| protected[this]         | 同`private[this]`                     |



```scala
package james

abstract class Behavior[T](private[james] val _tag: Int) { behavior =>

  final def narrow[U <: T]: Behavior[U] = this.asInstanceOf[Behavior[U]]

  private[james] final def unsafeCast[U]: Behavior[U] = this.asInstanceOf[Behavior[U]]

}
```

```java
package james;

import scala.reflect.ScalaSignature;

public abstract class Behavior {
   private final int _tag;

   public int _tag() {
      return this._tag;
   }

   public final Behavior narrow() {
      return this;
   }

   public final Behavior unsafeCast() {
      return this;
   }

   public Behavior(final int _tag) {
      this._tag = _tag;
   }
}

package james;

import scala.reflect.ScalaSignature;

public abstract class Behavior {
   private final int _tag;

   public int _tag() {
      return this._tag;
   }

   public final Behavior narrow() {
      return this;
   }

   public final Behavior unsafeCast() {
      return this;
   }

   public Behavior(final int _tag) {
      this._tag = _tag;
   }
}
```