module Main where

import           Control.Concurrent
import           Control.Concurrent.Async
import           Control.Monad
import           Data.Metrics

main :: IO ()
main = do
  m <- meter
  void . async $ forever $ do
    mark m
    threadDelay (10^6) -- One mark pro second
  forever $ do
    oneMinuteRate' <- oneMinuteRate m
    meanRate' <- meanRate m
    putStrLn $ "oneMinuteRate: " ++ show oneMinuteRate' ++  "; meanRate: " ++ show meanRate'
    threadDelay (10^6)
