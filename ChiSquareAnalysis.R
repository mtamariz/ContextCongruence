a <- read.csv("DATA_SEPT22", sep = "\t")
str(a)

t <-  table(a$TransmissionContext_0_ExpertNovice_1_PeerPeer, a$Produced_0_Expert_1_Peer)

chisq.test(c(t[1],t[3]))  # chi square of expert's and peer's variants transmitted in the expert-to novice onward transmission context
chisq.test(c(t[2],t[4]))  # chi square of expert's and peer's variants transmitted in the peer-to-peer onward transmission context

chisq.test(c(t[1],t[2]))  # chi square of expert's variants transmitted in the expert-to novice and  peer-to-peer onward transmission contexts
chisq.test(c(t[3],t[4]))  # chi square of expert's variants transmitted in the expert-to novice and  peer-to-peer onward transmission contexts


chisq.test(table(a$Variant_0_Parity_1_Skipping))   # No significant difference between the number of times Parity and Skipping variants were produced.

chisq.test(table(a$InputOrder_0_ExpertFirst_1_PeerFrist,a$Produced_0_Expert_1_Peer))  # The transmitted variant (Expert's or Peer's) was not associated with the order of learning contexts (first from an Expert or first from a Peer

chisq.test(table(a$VariantOrder_0_ParityFirst_1_SkippingFirst,a$Produced_0_Expert_1_Peer))   # The transmitted variant (Expert's or Peer's) was not associated with the order of presentation of the Parity and Skipping variants
