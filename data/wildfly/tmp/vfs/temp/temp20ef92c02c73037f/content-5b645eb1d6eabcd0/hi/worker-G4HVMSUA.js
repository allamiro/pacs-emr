var l,r=0;addEventListener("message",({data:e})=>{if(e&&e.serverTime){let s=new Date(e.serverTime);clearInterval(l),e.idle||(l=setInterval(()=>{s.setMilliseconds(s.getMilliseconds()+1e3),r>600&&!e.idle?(postMessage({serverTime:s,refresh:!0}),r=0):(postMessage({serverTime:s,refresh:!1}),r++)},1e3))}});
/**i18n:80979631044776d09105e57f5b471359e445ddd49859aceda3999a901c676dd1*/
