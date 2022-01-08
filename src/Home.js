import { ethers } from 'ethers'
import { useEffect, useState } from 'react'
import axios from 'axios'
import Web3Modal from "web3modal"
import "./style.css"

import {contractAddr} from "./addr";

import GameNft from "./artifacts/contracts/GameNft.sol/GameNft.json"



export default function Home() {
  const [nfts, setNfts] = useState([])
  const [addrr, setAdd] = useState('');
  const[unsoldNft, setUnsoldNft] = useState([])
  const [loadingState, setLoadingState] = useState('not-loaded')
  useEffect(() => {
    loadNFTs()
  }, [])
  async function loadNFTs() { 
      
    try{
    const web3modal = new Web3Modal();
    const connection = await web3modal.connect();
    const provider = new ethers.providers.Web3Provider(connection)
   const signer = provider.getSigner();
   const add = await signer.getAddress();
   setAdd(add)
//   console.log(add)
    const marketContract = new ethers.Contract(contractAddr, GameNft.abi, signer)
    const data = await marketContract.fetchForSaleMarketItems()
  
 
    const items = await Promise.all(data.map( async i => {
     const tokenUri = i.uri;
      const meta = await axios.get(i.uri)
    console.log(meta.data)
      let price = ethers.utils.formatUnits(i.price.toString(), 'ether')
      let item = {
        price,
        itemId: i.tokenId.toNumber(),
        seller: i.seller,
        owner: i.owner,
        forSale: i.forSale,
        image: meta.data.image,
        name: meta.data.name,
        description: meta.data.description,
      }
      return item
    }))

    setNfts(items)
    // console.log(nfts)
let unitem = items.filter(item => (item.seller===addrr));
setUnsoldNft(unitem)
console.log(unitem)
    setLoadingState('loaded')

} catch(err){console.log(err)} 
  }

 

  if (loadingState === 'loaded' && !nfts.length) return (<h1 className="px-20 py-10 text-3xl">No items in marketplace</h1>)
  return (
    <div className="container-top">
      <div className="px-4" style={{ maxWidth: '1600px' }}>
        <div className="wrapper">
          {
            nfts.map((nft, i) => (
              <div key={i} className="nftclass">
                <img src={nft.image} className='image' />
                <div className="p-4">
                  <p style={{ height: '64px' }} className="text-2xl font-semibold">{nft.name}</p>
                  
                    <p className="text-gray-400">{nft.description}</p>
             
                </div>
                <div className="p-5">
                  <p className="text-2xl mb-4 font-bold text-white">{nft.price} ETH</p>
               
                </div>
              </div>
            ))
          }
        </div>
      </div>
    </div>
  )
}
