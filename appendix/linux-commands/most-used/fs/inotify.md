

#### `inotify`可以监视的文件系统事件包括如下几个方面。
- `IN_ACCESS`：文件被访问。
- `IN_MODIFY`：文件被`write`。
- `IN_ATTRIB`：文件属性被修改，如`chmod`、`chown`、`touch`等。
- `IN_CLOSE_WRITE`：可写文件被`close`。
- `IN_CLOSE_NOWRITE`：不可写文件被`close`。
- `IN_OPEN`：文件被`open`。
- `IN_MOVED_FROM`：文件被移走，如`mv`。
- `IN_MOVED_TO`：文件被移来，如`mv`、`cp`。
- `IN_CREATE`：创建新文件。
- `IN_DELETE`：文件被删除，如`rm`。
- `IN_DELETE_SELF`：自删除，即一个可执行文件在执行时删除自己。
- `IN_MOVE_SELF`：自移动，即一个可执行文件在执行时移动自己。
- `IN_UNMOUNT`：宿主文件系统被`unmount`。
- `IN_CLOSE`：文件被关闭，等同于 (`IN_CLOSE_WRITE|IN_CLOSE_NOWRITE`)。
- `IN_MOVE`：文件被移动，等同于 (`IN_MOVED_FROM|IN_MOVED_TO`)。