# RoomAssignment

This is an optimization built for assigning people to dorm rooms based on age, gender, siblings, and group membership. It uses IBM ILOG CPLEX as the optimization engine with a multi-objective maximization using IBM's Optimization Programming Language (OPL). There is a free community edition availble that is limited to 1,000 variables and constraints. The dataset contains more than is allowed and is thus limited in the pre-processing step to not go over the limit. Using constraint programming vs MIP allows for slightly more data but is not as efficient.

### Problem

Many people from different groups are coming to an overnight activity. People will be housed in a college dorm and must be assigned rooms. Room assignments must conform to certain constraints and be optimized to avoid problems.

### Data

Rooms: unique room number (string), dorm hall, floor number, number of beds, allowed gender  
People: unique ID, gender, group membership/unit, age, sibling ID (same ID > 0 for siblings)

### Constraints

1. Number of people assigned to a room must not exceed the number of beds in the room.
2. A person may not be assigned to more than one room.
3. Person's gender must be the same as the allowed gender of the room.

### Optimizations

* Maximize the number of people assigned to a room
* Minimize the difference in ages within any given room
* Minimize the number of rooms with only one person assigned
* Minimize the number of rooms with people from the same group membership
* Minimize the number of rooms with siblings assigned to the same room

