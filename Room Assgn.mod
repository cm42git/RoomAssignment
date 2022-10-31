/*********************************************
 * OPL 22.1.0.0 Model
 * Author: chris
 * Creation Date: May 13, 2022 at 9:58:18 PM
 *********************************************/
//using CP;

tuple roomTup {
  string room_nbr;
  string hall;
  int floor_nbr;
  int beds;
  string allowed_gender;
  string type;
  string member;
}
{roomTup} roomsIn = ...;

tuple peopleTup {
  int id;
  string gender;
  string unit;
  int age;
  int sibling;
  string type;
  string member;
}
{peopleTup} peopleIn = ...;


tuple roomTup2 {
  string room_nbr;
  string hall;
  int floor_nbr;
  int beds;
  string allowed_gender;
  string type;
  string member;
  string room_ltr;
}
{roomTup2} roomsIn2 = {};

execute {
 for (var r in roomsIn) {
   var r2 = roomsIn2.add(r.room_nbr,
   r.hall,
   r.floor_nbr,
   r.beds,
   r.allowed_gender,
   r.type,
   r.member,
   r.room_nbr.charAt(3));
  } 
}

{roomTup2} rooms = { r | r in roomsIn2 : r.floor_nbr==3 && r.room_ltr=="B" };
{peopleTup} people = { cd | cd in peopleIn : 13 <= cd.age <= 14 && cd.gender=="MALE" };

sorted {string} units = { c.unit | c in peopleIn };
{int} siblings = { c.sibling | c in peopleIn : c.sibling>0 };

execute {writeln(units); writeln(siblings);}

dvar boolean assign[rooms,people];
dvar int maxDelta;
dexpr int minAge[r in rooms] = 100000-max(c in people) assign[r,c]*(100000-c.age);
dexpr int maxAge[r in rooms] = max(c in people) assign[r,c]*c.age;
dexpr int alone[r in rooms] = (sum(c in people) assign[r,c])==1;
dexpr int unitsPerRoom[r in rooms,u in units] = (sum(c in people:c.unit==u)assign[r,c]);
dexpr int sibsPerRoom[r in rooms,s in siblings] = (sum(c in people:c.sibling==s)assign[r,c]);
dexpr int totalAssigned = sum(r in rooms, c in people) assign[r, c];

maximize staticLex(
totalAssigned
,-maxDelta
,sum(r in rooms) -alone[r]
,sum(r in rooms, u in units) -(unitsPerRoom[r,u]>=2)
,sum(r in rooms, s in siblings) -(sibsPerRoom[r,s])
);

subject to {
  forall (r in rooms) {
   maxDelta>=(maxAge[r]-minAge[r]);
   sum(c in people) assign[r,c]<=r.beds; 
  }  
  
  forall (c in people) sum(r in rooms) assign[r,c]<=1;
  
  forall (c in people,r in rooms : r.allowed_gender!=c.gender) assign[r,c]==0;
}

tuple assignTup {
  string room_nbr;
  string hall;
  int floor_nbr;
  int beds;
  string allowed_gender;

  int capid;
  string gender;
  string unit;
  int age;
  int sibling;
  
  int assigned;
}

{assignTup} assignPre = {
  <r.room_nbr,
  r.hall,
  r.floor_nbr,
  r.beds,
  r.allowed_gender,
  
  c.id,
  c.gender,
  c.unit,
  c.age,
  c.sibling,
  
  assign[r,c]> | r in rooms, c in people
};

{assignTup} assignFinal = { ap | ap in assignPre : ap.assigned==1};

execute {
  writeln(assignFinal);
  writeln(unitsPerRoom);
}
