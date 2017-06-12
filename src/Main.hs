module Main where

import           Control.Concurrent
import           Control.Concurrent.Async
import           Control.Monad
import           Data.Metrics

-- Produces something along the lines:
--   $ stack exec metrics-test
--   oneMinuteRate: 0.0; meanRate: 0.0
--   oneMinuteRate: 0.0; meanRate: 9.994109921347304e-13
--   oneMinuteRate: 0.0; meanRate: 9.992588761719036e-13
--   oneMinuteRate: 0.0; meanRate: 9.99204537597505e-13
--   oneMinuteRate: 0.0; meanRate: 9.991544360834085e-13
--   oneMinuteRate: 5.0; meanRate: 9.991315820053e-13
--   oneMinuteRate: 5.0; meanRate: 1.1656576555266255e-12
--   oneMinuteRate: 5.0; meanRate: 9.99128052384729e-13
--   oneMinuteRate: 5.0; meanRate: 9.991146947099432e-13
--   oneMinuteRate: 5.0; meanRate: 9.991089518970375e-13
--   oneMinuteRate: 5.0; meanRate: 9.990965934813138e-13
--   oneMinuteRate: 5.0; meanRate: 1.0899066451107885e-12
--   oneMinuteRate: 5.0; meanRate: 9.990748603425973e-13
--
-- Would have expected both values to approach one?

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
