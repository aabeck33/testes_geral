# SuperFastPython.com
# example of async for loop with task list comprehension
import asyncio
import time

def works(data):
    # simulate some work
    time.sleep(1)
    # report a message
    print(f'>task done with {data}')
 
def mains():
    # report a message
    print('Mains starting')
    # create all tasks
    for i in range(QTD):
        works(i)
    # report a message
    print('Mains done')


# async task
async def work(data):
    # simulate some work
    await asyncio.sleep(1)
    # report a message
    print(f'>task done with {data}')
 
# main coroutine
async def main():
    # report a message
    print('Main starting')
    # create all tasks
    tasks = [asyncio.create_task(work(i)) for i in range(QTD)]
    # wait on tasks one by one
    for task in tasks:
        await task
    # report a message
    print('Main done')

QTD = 50
init_time1 = time.time()
mains()
final_time1 = time.time()
print('Tempo: '+ str(final_time1 - init_time1) + ' seconds')
# start the event loop
init_time2 = time.time()
asyncio.run(main())
final_time2 = time.time()
print('Tempo: '+ str(final_time2 - init_time2) + ' seconds')