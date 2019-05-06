package main

import (
	"database/sql"
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"time"

	_ "github.com/go-sql-driver/mysql"
	"github.com/gorilla/mux"
)

func main() {
	router := mux.NewRouter().StrictSlash(true)
	router.HandleFunc("/login", Login).Methods("POST")
	router.HandleFunc("/createUser", CreateUser).Methods("POST")
	router.HandleFunc("/createRide", CreateRide).Methods("POST")
	router.HandleFunc("/findUserRide", FindUserRide).Methods("POST")
	router.HandleFunc("/deleteRide", DeleteRide).Methods("POST")
	router.HandleFunc("/locations", Locations).Methods("GET")
	log.Fatal(http.ListenAndServe(":3000", router))
}

func GetMySQLDB() (db *sql.DB, err error) {
	dbDriver := "mysql"
	dbHost := "mysql"
	dbPort := "3306"
	dbUser := "root"
	dbPass := "password"
	dbName := "BackNinesDB"
	d, err := sql.Open(dbDriver, fmt.Sprintf("%s:%s@tcp(%s:%s)/%s?parseTime=true", dbUser, dbPass, dbHost, dbPort, dbName))
	if err != nil {
		return nil, err
	}
	return d, nil
}

type login struct {
	Email    string `json:"email"`
	Password string `json:"password"`
}

//Login user login
func Login(w http.ResponseWriter, r *http.Request) {
	var l login
	err := json.NewDecoder(r.Body).Decode(&l)
	if err != nil {
		log.Println("failed to decode json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	//check db user
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	var u login
	err = db.QueryRow(fmt.Sprintf("SELECT email, user_password FROM Users WHERE email = '%s' AND user_password = '%s';", l.Email, l.Password)).Scan(&u.Email, &u.Password)
	if err != nil {
		fmt.Println(err)
		log.Println("could not auth user")
		w.WriteHeader(http.StatusForbidden)
		return
	}

	w.Header().Add("Content-Type", "application/json")
	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(&u)
}

type user struct {
	Email     string `json:"email"`
	Password  string `json:"password"`
	FirstName string `json:"fname"`
	LastName  string `json:"lname"`
	Cell      string `json:"cell"`
	DeptName  string `json:"deptName"`
	FullTime  string `json:"fullTime"`
	PosName   string `json:"position"`
	GradYear  string `json:"gradYear"`
	Birthday  int64  `json:"birthday"`
	Admin     string `json:"admin"`
}

//CreateUser creates a new user
func CreateUser(w http.ResponseWriter, r *http.Request) {
	var u user
	err := json.NewDecoder(r.Body).Decode(&u)
	if err != nil {
		log.Println("failed to decode json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	//create user
	//check db
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		return
	}

	res, err := db.Exec("call registerUser(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)",
		u.Email,
		u.Password,
		u.FirstName,
		u.LastName,
		u.Cell,
		u.DeptName,
		u.FullTime,
		u.PosName,
		u.Admin,
		u.GradYear,
		time.Unix(u.Birthday, 0),
		time.Now().UTC(),
	)

	id, err := res.LastInsertId()
	if err != nil {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed get row id"))
		return
	}

	if id == 0 {
		if err != nil {
			w.WriteHeader(http.StatusBadRequest)
			w.Write([]byte("failed to find user"))
		}
		return
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusNoContent)
}

type resp struct {
	ID int64 `json:"id"`
}

type createRide struct {
	Email     string `json:"email"`
	FirstName string `json:"fname"`
	LastName  string `json:"lname"`
	Cell      string `json:"cell"`
	StartLoc  string `json:"startLoc"`
	EndLoc    string `json:"endLoc"`
	StartTime int64  `json:"startTime"`
}

//CreateRide creates a new ride
func CreateRide(w http.ResponseWriter, r *http.Request) {
	var c createRide
	err := json.NewDecoder(r.Body).Decode(&c)
	if err != nil {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		log.Println("failed to decode json")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	//create ride
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	_, err = db.Exec("call createRide(?, ?, ?, ?, ?, ?, ?)",
		c.FirstName,
		c.LastName,
		c.Email,
		c.Cell,
		c.StartLoc,
		c.EndLoc,
		time.Unix(c.StartTime, 0),
	)

	if err != nil {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to create ride"))
		return
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.WriteHeader(http.StatusOK)
	w.Header().Add("content/type", "application/json")
}

type findRide struct {
	Email     string `json:"email"`
	Password  string `json:"password"`
	FirstName string `json:"fname"`
	LastName  string `json:"lname"`
}

type ride struct {
	RideID    string `json:""`
	FirstName string `json:"fname"`
	LastName  string `json:"lname"`
	StartLoc  string `json:"startLoc"`
	EndLoc    string `json:"endLoc"`
	StartTime int64  `json:"startTime"`
}

type rideResp struct {
	Rides []ride `json:"rides"`
}

//FindUserRide finds a user a new ride
func FindUserRide(w http.ResponseWriter, r *http.Request) {
	var fr findRide
	err := json.NewDecoder(r.Body).Decode(&fr)
	if err != nil {
		log.Println("failed to decode json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	rows, err := db.Query("call finduserRide(?, ?, ?, ?)",
		fr.FirstName,
		fr.LastName,
		fr.Email,
		fr.Password,
	)
	if err != nil {
		fmt.Println(err)
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed get row id"))
		return
	}

	//scan return to here
	rides := make([]ride, 0)

	for rows.Next() {
		var r ride
		var i time.Time
		err := rows.Scan(
			&r.RideID,
			&r.FirstName,
			&r.LastName,
			&r.StartLoc,
			&r.EndLoc,
			&i,
		)
		if err != nil {
			fmt.Println(err)
			continue
		}

		r.StartTime = i.UTC().Unix()

		rides = append(rides, r)
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(&rideResp{
		Rides: rides,
	})
}

type deleteRide struct {
	ID        int64  `json:"id"`
	FirstName string `json:"fname"`
	LastName  string `json:"lname"`
	StartLoc  string `json:"startLoc"`
	EndLoc    string `json:"endLoc"`
	StartTime int64  `json:"startTime"`
}

//DeleteRide deletes a user's ride
func DeleteRide(w http.ResponseWriter, r *http.Request) {
	var d deleteRide
	err := json.NewDecoder(r.Body).Decode(&d)
	if err != nil {
		log.Println("failed to decode json")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	//delete ride
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	_, err = db.Exec("call deleteRide(?, ?, ?, ?, ?, ?)",
		d.ID,
		d.FirstName,
		d.LastName,
		d.StartLoc,
		d.EndLoc,
		time.Unix(d.StartTime, 0),
	)

	if err != nil {
		fmt.Println(err)
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed get row id"))
		return
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(http.StatusNoContent)
}

type location struct {
	ID      int    `json:"id"`
	Name    string `json:"name"`
	Address string `json:"address"`
}

type locationResp struct {
	Loc []location `json:"loc"`
}

//Locations returns all locations
func Locations(w http.ResponseWriter, r *http.Request) {
	//locations
	//check db user
	db, err := GetMySQLDB()
	if err != nil {
		log.Println("failed database connection")
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusBadRequest)
		w.Write([]byte("failed to decode json"))
		return
	}

	rows, err := db.Query("SELECT locationId, locationName, locationAddress FROM BackNinesDB.Location;")
	if err != nil {
		w.Header().Set("Access-Control-Allow-Origin", "*")
		w.WriteHeader(http.StatusForbidden)
		log.Println("could not find locations")
		return
	}

	locs := make([]location, 0)

	for rows.Next() {
		var l location
		err := rows.Scan(
			&l.ID,
			&l.Name,
			&l.Address,
		)
		if err != nil {
			continue
		}

		locs = append(locs, l)
	}

	w.Header().Set("Access-Control-Allow-Origin", "*")
	w.Header().Add("Content-Type", "application/json")
	w.WriteHeader(http.StatusOK)
	json.NewEncoder(w).Encode(&locationResp{
		Loc: locs,
	})
}
