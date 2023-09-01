import { useState } from 'react'
import reactLogo from './assets/react.svg'
import viteLogo from '/vite.svg'
import starknetLogo from './images/starknet.png'
import starkBackground from './images/stark.jpg'
import dice from './images/dice.png'
import 'w3-css/w3.css';
// import './App.css'

function App() {
  const [count, setCount] = useState(0)

  return (
    <>
      <div className='w3-center' style={{ backgroundColor: "rgba(0,0,0,0.5)", width: "100%", height: "100%" }}>
        <div className='w3-center' >
          <br />
          <br />
          <br />
          <br />
          <br />
          <br />
          <img src={starknetLogo} className='w3-image' style={{ width: '150px' }} />

          <img src={dice} className="w3-image" style={{ width: '150px' }} />
        </div>
        <div className='w3-center'>
          <h1 className='w3-text-white' style={{ fontWeight: 'bold', fontSize: 67 }}>STARKDICE</h1>
          <p className='w3-text-white' style={{ fontSize: '20px', textTransform: 'uppercase', fontWeight: 200 }}>Elevate Your Ludo Experience with StarkNet</p>

        </div>
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />
        <br />

      </div>
    </>
  )
}

export default App
