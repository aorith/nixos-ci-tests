package main

import (
	"bufio"
	"flag"
	"fmt"
	"net"
	"os"
	"strconv"
)

func main() {
	port := flag.Int("port", 8080, "port to listen on")
	flag.Parse()

	if *port < 1024 || *port > 65535 {
		fmt.Println("Port number must be between 1024 and 65535.")
		os.Exit(1)
	}

	listener, err := net.Listen("tcp", ":"+strconv.Itoa(*port))
	if err != nil {
		fmt.Println("Error starting the server:", err)
		os.Exit(1)
	}
	defer listener.Close()
	fmt.Printf("Server is listening on port %s\n", strconv.Itoa(*port))

	for {
		conn, err := listener.Accept()
		if err != nil {
			fmt.Println("Error accepting connection:", err)
			continue
		}

		go handleConnection(conn)
	}
}

func handleConnection(conn net.Conn) {
	defer conn.Close()
	scanner := bufio.NewScanner(conn)
	for scanner.Scan() {
		text := scanner.Text()
		fmt.Println("Received:", text)
		if _, err := conn.Write([]byte(text + "\n")); err != nil {
			fmt.Println("Error writing output:", err)
		}
	}
	if err := scanner.Err(); err != nil {
		fmt.Println("Error reading from connection:", err)
	}
}
