#!/bin/sh

sed -i 's/,etbb\]/,lucida]/' $@
sed -i 's/\[etbb,/\[lucida,/' $@
