from __future__ import annotations

from typing import Optional, List, Dict
import datetime

from pydantic import BaseModel, Field

class Coordinates(BaseModel):
    lat: float = Field(..., description="latitude")
    long: float = Field(..., description="longitude")


class LocationUpdate(BaseModel):
    id: str = "1234"
    activity: str = "test"
    #start: int = Field(..., description="start timestamp")
    floor: int = 1
    timestamp: float = Field(..., description="creation of construction site")

class ConstructionSite(BaseModel):
    id: str = Field(..., description="construction site id")
    coords: Coordinates = Field(..., description="construction site coordinates")
    timestamp: int = Field(..., description="creation of construction site")
    
import redis 
import json
from geopy import distance
import time
import uuid

from fastapi import FastAPI
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware

from starlette.responses import RedirectResponse
from pydantic import BaseModel, Field

app = FastAPI(port=5055)

origins = [
    # "http://89.217.35.146:50080",
    # "http://89.217.35.146:50080/",
    # "http://localhost",
    # "http://localhost:8080",
    "*",
]

app.add_middleware(
    CORSMiddleware,
    allow_origins=origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# redis client
r = redis.StrictRedis(port=6380 )
# initialize empty list for all objects
r.execute_command('JSON.SET', 'elevatorstate', '.', '{}')
# r.execute_command('JSON.SET', 'cs', '.', '{}')
 

@app.get("/")
async def get_app():
    return RedirectResponse(url='dev.bru.lu/docs')

@app.get('/demo/')
async def get_demo():

    return {'test':'hi i love you sue'}

def get_all(kind:str='trucks'):
    # gets list of all objects of a kindxj
    all_trucks = json.loads(r.execute_command('JSON.GET', kind).decode())
    
    ret = []
    # iterate over dict of tracks
    for key, truck in all_trucks.items():

        delta_time = truck['timestamp'] - truck['start']
        perc = delta_time / (90*60)

        if perc >1.:
            perc = 1.

        if perc < 0.:
            perc = 0.

        truck['time_per'] = perc
        ret.append(truck)

    return ret

# update location
def location_update(update, kind:str='elevatorstate'):
    
    # load all trucksf
    temp = r.execute_command('JSON.GET', kind)
    print(temp)
    if temp:
        trucks = json.loads(temp.decode())
    else:
        return 'hi'

    if trucks is not None and update.id in trucks.keys():
        
        truck = trucks[update.id]
        update = json.loads(update.json())

        truck['floor'] = update['floor']
        truck['activity'] = update['activity']
        truck['timestamp'] = time.time()

        # set id
        r.execute_command('JSON.SET', kind, truck['id'], json.dumps(truck))

    # new truck
    else: 
        update = json.loads(update.json())
        update['timestamp'] = time.time()
        #import pprint; pprint.pprint(update)
        r.execute_command('JSON.SET', kind, update['id'], json.dumps(update))

    return 

"""
#@app.get("/get_all_trucks")
#async def get_all_trucks():
#    return {"all_trucks": get_all('trucks')}

#@app.get("/get_all_cs")
#async def get_all_trucks():
#    return {"all_cs": get_all('cs')}

"""

@app.put("/elevatorstate/update")
def state_update(update:LocationUpdate):
    print(update, type(update))
    return location_update(update,kind='elevatorstate')


@app.get("/elevatorstate/{truck_id}")
async def read_item(truck_id):
    truck =  json.loads(r.execute_command('JSON.GET', 'elevatorstate', truck_id).decode())
    print(truck)
    return truck


## construction sites
"""
@app.put("/cs/update")
def init_cs(cs):
    return location_update(cs,kind='cs')
    # r.execute_command('JSON.SET', cs.id, '.', json.dumps(cs.json()))
    # r.execute_command('JSON.ARRAPPEND', 'cs', '.', json.dumps(cs.json()))
    


@app.get("/cs/{cs_id}")
async def get_cs(cs_id):
    cs =  json.loads(r.execute_command('JSON.GET', 'cs', truck_id).decode())
    
    return cs

def get_dist_in_km(a: tuple):
    '''
    get the distance from construction site a to all other construction sites
    '''

    # get all the other construction sites
    construction_sites = json.loads(r.execute_command('JSON.GET', 'construction_sites').decode())
    construction_sites = [json.loads(track_string) for cs in construction_sites]

    # loop over construction sites
    sites = []
    for cs in construction_sites:
        coords = (cs.coords.lat, cs.coords.long)
        dist = distance.distance(a, cs).km
        if dist < 10:
            sites.append(cs)

    return sites
"""

@app.get("/get_id")
async def random_id():
    return uuid.uuid4()


@app.post("/hook")
def hook(payload:dict):
    print(payload)
    return payload

# static file serving
# app.mount("/static", StaticFiles(directory="static"), name="static")
