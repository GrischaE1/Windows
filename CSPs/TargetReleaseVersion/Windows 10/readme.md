Please be aware that the new Productversion setting is only supported with Windows 10 2004 and above. 
If you want to upgrade 1909 or earlier, you need first update to 2004 or later.

Also you would need to remove the following code from the CSP:
  <Item>
    <Target>
        <LocURI>./Device/Vendor/MSFT/Policy/Config/Update/ProductVersion</LocURI>
      </Target>
    <Meta>
      <Format xmlns="syncml:metinf">chr</Format>
      <Type>text/plain</Type>
    </Meta>
    <Data>Windows 10</Data>
  </Item>
  
  All devices with 2004 or later can use the CSP as they are!
