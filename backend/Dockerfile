FROM golang:1.11
WORKDIR $GOPATH/src/main/
COPY . .
RUN go get "github.com/go-sql-driver/mysql"
RUN go get "github.com/gorilla/mux"
RUN go install
EXPOSE 3000
CMD ["main"]