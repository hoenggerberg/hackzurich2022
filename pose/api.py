import httpx

floor = ["Parking"] + [f'Floor {floor}' for floor in range(11)]

def from2(target_floor:int, origin_floor:int, car:int=4):

    payload = {
            "asyncId": "c953e1d643",
            "options": {
                "terminalFeedback": False,
                "cars": [
                    {
                        "building": 1,
                        "group": 1,
                        "car": 4
                    }
                ],
                "destination": {
                    "destinationFloor": str(origin_floor),
                    "destinationZone": floor[origin_floor+1]
                }
            },
            "target": {
                "floor": str(target_floor),
                "zone": floor[target_floor+1]
            }
        }
    print(payload)
    res = httpx.post(url="https://hack1.myport.guide/publish/", json=payload)

    print(res)

# from2(2, 9,1)
# from2(2, -1,2)
# from2(2, 3,3)
# from2(2, 1,4)