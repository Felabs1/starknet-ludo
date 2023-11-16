import React, { useState, useEffect } from "react";
import { Link } from "react-router-dom";
import { v4 as uuid } from "uuid";
import "./Join.css";
import { Contract, Provider, constants } from "starknet";
import { connect, disconnect } from "starknetkit";

function Join({ socket, history }) {
  const [name, setName] = useState("");
  const [room, setRoom] = useState("");
  const [connection, setConnection] = useState();
  const [account, setAccount] = useState();
  const [address, setAddress] = useState();
  const [retrievedValue, setRetrievedValue] = useState("");

  let uid = uuid().slice(0, 8);
  const inputRef = React.useRef();

  // const connectWallet = async () => {
  //   const connection_ = await connect({
  //     webWalletUrl: "https://web.argent.xyz",
  //   });
  //   if (connection_ && connection_.isConnected) {
  //     setConnection(connection_);
  //     setAccount(connection_.account);
  //     setAddress(connection_.selectedAddress);
  //   }
  // };
  // const disconnectWallet = async () => {
  //   await disconnect();
  //   setConnection(undefined);
  //   setAccount(undefined);
  //   setAddress("");
  // };

  function handleClick(e) {
    let roomId,
      host = false;
    let room_id = inputRef.current.value;
    setRoom(room_id);
    if (!name) e.preventDefault();
    if (e.target.id === "jn") {
      roomId = room_id;
      if (!room_id) e.preventDefault();
    } else {
      roomId = uid;
      host = true;
    }

    console.log(console.log(room));

    socket.emit("join", { roomId, name, host }, () => {
      history.push("/" + roomId);
    });
  }

  useEffect(() => {
    setRoom(window.location.href.split("#")[1]);
  });

  return (
    <div className="joinOuterContainer">
      <div className="joinInnerContainer">
        <button
          style={{
            marginTop: "-20px",
            display: "block",
            width: "100%",
            padding: "12px",
            border: 0,
            background: "#990000",
            color: "#fff",
            backgroundImage:
              "linear-gradient(90deg, rgba(2,0,36,1) 0%, rgba(9,9,121,1) 35%, rgba(0,212,255,1) 100%);",
          }}
        >
          Connect Wallet
        </button>

        <h1 className="heading">Ludo.io</h1>
        <div>
          <input
            placeholder="Name"
            className="joinInput"
            type="text"
            onChange={(event) => {
              setName(event.target.value);
            }}
          />
          <input
            placeholder="Room Id"
            className="joinInput mt-20"
            ref={inputRef}
            type="text"
            onChange={(event) => {
              setRoom(event.target.value);
            }}
            // value={room || ""}
          />
        </div>
        <Link
          onClick={handleClick}
          id="jn"
          to={`/${room}`}
          className="button mt-20"
        >
          Join Room
        </Link>
        <Link
          onClick={handleClick}
          id="cr"
          to={`/${uid}`}
          className="button mt-20"
        >
          Create Room
        </Link>
      </div>
    </div>
  );
}

export default Join;
