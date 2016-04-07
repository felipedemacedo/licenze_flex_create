#!/bin/bash

sed -i 's/{targetPlayerMajorVersion}/10.0/g' $flexlib/flex-config.xml && grep -r -l "com/images" /Licenze_Flex_3_6/src/com/* | xargs sed -i "s/com\/images/\/com\/images/g"

mxmlc -load-config config/config-compiler.xml Licenze_Flex_3_6/src/new_boq.mxml -output output/new_boq.swf
