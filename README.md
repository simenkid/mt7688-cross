# mt7688-cross
The tool to create an environment on a Host for cross-compiling node.js native modules/add-ons for MT7688 mips platform. Once the environment is created, just use `./npm_install.sh` to install the cross-compiled version of node modules, it's easy.  

**IMPORTANT**
[2016/07/26] Since google has removed the gyp repo from svn to git, you'll get a problem of `svn: E160013: Unable to connect to a repository at URL 'http://gyp.googlecode.com/svn/trunk'` when running `./create_env.sh`. I'll try to fix this asap.  

You may like to try the [docker image](https://labs.mediatek.com/forums/posts/list/4445.page) for the cross-build environemnt bulit by sonnyyu.  


## 1. Information about the Host and Target  

* Host: Ubuntu/Debian x86_64 (Mine is Ubuntu 14.04 LTS running on a virtual machine)
* Target: MT7688, MIPS24KEc (little endian)  
    * node.js: 0.12.7
    * npm: 2.11.3
    * v8 engine: 3.28.71 (patch 19)  

</br>
## 2. Preacquisition  

</br>
#### step 1: Install the following packages on your Host PC  

` $ sudo apt-get install subversion build-essential gcc-multilib g++-multilib`  

</br>
#### step 2: Make sure you are equipped with **node@0.12.7** and **npm@2.11.3** on your Host PC
If you don't, try to install them: (I am using `n` as my node version manager. You can use `nvm` if you like.)  

`$ sudo n 0.12.7`  
`$ sudo npm install -g npm@2.11.3`  

</br>
#### step 3: Clone **mt7688-cross** to the Host PC  

`~$ git clone https://github.com/simenkid/mt7688-cross.git`  
`~$ cd mt7688-cross`  
`~/mt7688-cross$`  

mt7688-cross/ is the working directory for cross-compiling native node modules/add-ons.  

</br>
#### step 4: Build the environment  
Shoot `create_env.sh` to start the building process. This may take around 20 minutes depends on your PC performance.  

`~/mt7688-cross$ ./create_env.sh`  

</br>
As building accomplished,  in`linkit/opt/`, there is the cross-compiled node.js that can run on MT7688 MIPS platform. In addition, `v8/`, `node-v0.12.7-mips/`, and `mt7688sdk/` are the sources of v8, node, and mt7688 SDK, respectively.  

Once this step is successfully done, the environment is ready for your later use. Every time you want to cross-compile a node native module, just come into the working directory `mt7688-cross/` and install a module with script `npm_install.sh`, there is no need to rebuild the environment again.  

</br>
## 3. Install the cross-compiled node native module/add-on  

Assume that you like to install the `serialport` module on your MT7688. First install it with `npm_install.sh` on the Host:  

`~/mt7688-cross$ ./npm_install.sh serialport`  

You will get a compressed tarball in `node_modules_mips/`, in this example, it is `serialport-2.0.6_mips.tar.gz`. If you like to install other version, just specify the version with `@`:  

`~/mt7688-cross$ ./npm_install.sh serialport@2.0.4`  

Next step is push it to MT7688 via `scp` and decompress it to any place you want. In this example, I will put it to `~/app` with the root account and extract it to `~/app/node_modules/`.  

**At Host:**  

`~/mt7688-cross$ scp node_modules_mips/serialport-2.0.6_mips.tar.gz root@192.168.0.109:/root/app`  

**At Target:**  

`root@mylinkit:~/app# tar xvf serialport-2.0.6_mips.tar.gz -C node_modules/`  

Now, you are ready to write a script in `~/app` on your target.  

</br>
## Note

1. Module cross-build may fail if the module is highly platform-dependent, e.g. module that operates SoC gpio/uart and other peripherals. 
2. Module cross-build may fail if the module requires some libraries that SDK doesn't provide. 
3. You are welcome to modify this script to fit your needs, e.g. automation of file transmission from Host to Target.
4. If you only like to have the environment variable settings for cross tools, it is in `env.sh`.

This tool is inspired by [Build your own Node.js package with the linino toolchain](http://wiki.linino.org/doku.php?id=wiki:nodepackage). Thanks to linino!
