/*********************************************
 * OPL 22.1.0.0 Model
 * Author: Alex Fleischer
 * Creation Date: May 17, 2022 at 10:11:25 PM
 *********************************************/


tuple room
{
int id;
int capacity;
}

tuple person
{
int id;
int age;
}

int big=100000;
int nbRooms=5;
int nbPersons=40;

{room} rooms={<i,10+rand(10)> |i in 1..nbRooms};
{person} persons={<i,18+rand(20)> |i in 1..nbPersons};

dvar boolean x[persons][rooms]; // Is a given person in a given room
dvar int minAge[rooms];
dvar int maxAge[rooms];
dvar int maxdelta;

// first try to assign all persons and then minimize max delta per room
maximize staticLex(sum(p in persons,r in rooms) x[p][r],-maxdelta);
subject to
{
forall(p in persons) sum(r in rooms) x[p][r]<=1; // a person is in 0 or 1 room

forall(r in rooms) sum(p in persons) x[p][r]<=r.capacity;

forall(r in rooms)
  {
     maxAge[r]==max(p in persons) p.age*x[p][r];
     minAge[r]==big-max(p in persons) (big-p.age)*(x[p][r]);
  }
 
forall(r in rooms) (maxAge[r]-minAge[r])<=maxdelta;  
} 