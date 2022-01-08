import Home from './Home';
import { BrowserRouter } from "react-router-dom";
import { Routes, Route, Link } from "react-router-dom";
import CreateItem from './create-item';
import MyAssets from './my-assets';
import SellNft from './sellNft';


function App() {
  return (
  <>
 
  
  
    <BrowserRouter>
    <p style={{fontSize: 25}}>Metaverse Marketplace</p>
      <div className="mt-4" style={{margin: "0 0 0 2rem"}}>
        <Link to="/">
            Home
        </Link>
                
        <Link to="/my-assets">
            My Digital Assets
        </Link>

        <Link to="/create-item">
            Create Assets
        </Link>
        <Link to="/sell-nft">
        
            Sell-Nft
        
        </Link>
      </div>
      <Routes>
        <Route path="/" element={<Home />} />
        <Route path="/create-item" element={<CreateItem />} />
        <Route path="/my-assets" element={<MyAssets />} />
        <Route path="/sell-nft" element={<SellNft />} />
      </Routes>

    </BrowserRouter>
</>
    
  );
}

export default App;
