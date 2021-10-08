#-*- coding:utf-8 -*-
import multiprocessing 
import time

def func(msg):    
    print(multiprocessing.current_process().name + '-' + msg)

if __name__ == "__main__":    
    pool = multiprocessing.Pool(processes=8) 
    # 创建8个进程    
    for i in range(10000):        
        msg = "hello {}".format(i)        
        pool.apply_async(func, (msg, ))    
    pool.close() # 关闭进程池,表示不能再往进程池中添加进程    
    pool.join()  # 等待进程池中的所有进程执行完毕,必须在close()之后调用    
    print("Sub-process(es) done.")