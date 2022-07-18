
        # notify end
        echo -e " \n${TEXT_GREEN}All apps Configured!${TEXT_RESET} \n" && sleep 5;;
        
  * )   # notify cancellation
        echo -e " \n${TEXT_YELLOW}Apps not configured.${TEXT_RESET} \n" && sleep 5;;
        
esac

# mark setup.sh
sed -i 's+bash ./cfg/5_usrapp.sh+#bash ./cfg/5_usrapp.sh+g' ~/.setup_cache/setup.sh
