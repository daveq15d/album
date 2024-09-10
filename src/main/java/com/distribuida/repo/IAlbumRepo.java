package com.distribuida.repo;

import com.distribuida.db.Album;
import io.quarkus.hibernate.orm.panache.PanacheRepositoryBase;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.transaction.Transactional;

@ApplicationScoped
@Transactional
public class IAlbumRepo implements PanacheRepositoryBase<Album,Integer> {
}
