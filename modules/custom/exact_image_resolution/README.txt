********************************************************************
       E X A C T  I M A G E  R E S O L U T I O N  M O D U L E
********************************************************************
Original Author: Gabriel Wong
Current Maintainers: Gabriel Wong
Email: gabrielkpwong@gmail.com

********************************************************************
DESCRIPTION:

   Exact image resolution module extends the image module giving the option to input exact image sizes, if an image uploaded is outside that dimension, it will be rejected.


********************************************************************

INSTALLATION:

1. Place the entire exact_image_resolution directory into sites modules directory
  (eg sites/all/modules).

2. Enable this module by navigating to:

     Administration > Modules


3) Please read the step by step instructions as an example to use this
   module below:-

a) Install the module.

b) Go to admin/structure page. Click on manage fields of any content type.

c) Any field using the "Image" Field type will now have the added Exact image resolution option added to it when editing the field.

d) When using this option, it would be best to remove any inputs in the "Maximum image resolution", and "Minimum image resolution".
